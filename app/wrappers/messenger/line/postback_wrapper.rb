module Messenger
  module Line
    class PostbackWrapper < BaseWrapper
      attr_reader :restaurant_data_subset_id, :page
      def post_initialize
        @restaurant_data_subset_id, @page = event["postback"]["data"].split("&").map { |data| data.split("=").last }
      end

      def validate
        recent_message = MessageRestaurantDataSubset.where(
          restaurant_data_subset_id: restaurant_data_subset_id,
          page: page
        ).order(created_at: "DESC").first

        if recent_message && recent_message.created_at > Time.current.ago(5.minutes)
          message_params = [{message_type: "text", chat_unit: recent_message.message.chat_unit, message: "5分以内にメッセージを送信しました。そちらをご確認ください。" }]
          return message_params
        end
      end

      def reply_error_messages(message_params)
        # どんなメッセージを送ってきたのかの履歴を見れる用
        ActiveRecord::Base.transaction do
          message_params.each do |param|
            message = Message.create_reply_message!(param)
            message.chat_unit.reply_to_entity([message])
          end
        end
      end

      def receive
        message = Message.create_receive_message!({
          chat_unit: chat_unit,
          message_type: :postback,
          restaurant_data_subset_id: restaurant_data_subset_id,
          page: page
        })

        return message
      end

      def reply
        # mongo_custom_restaurants = Mongo::CustomRestaurants.find(mongo_custom_restaurants_id)
        restaurant_data_subset = RestaurantDataSubset.find(restaurant_data_subset_id)
        search_history = restaurant_data_subset.restaurant_data_set.search_history
        # return unless search_history.is_outdated_cache_id
        
        Messenger::ReplyRestaurantsMessageWorker.perform_async(restaurant_data_subset_id, page)
      end
    end
  end
end
