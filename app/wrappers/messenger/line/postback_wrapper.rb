module Messenger
  module Line
    class PostbackWrapper < BaseWrapper
      attr_reader :mongo_custom_restaurants_id, :page
      def post_initialize
        @mongo_custom_restaurants_id, @page = event["postback"]["data"].split("&").map { |data| data.split("=").last }
      end

      def receive
        message = Message.create_receive_message!({
          chat_unit: chat_unit,
          message_type: :postback,
          mongo_custom_restaurants_id: mongo_custom_restaurants_id,
          page: page
        })

        return message
      end

      def reply
        mongo_custom_restaurants = Mongo::CustomRestaurants.find(mongo_custom_restaurants_id)
        search_history = SerachHistory.find_by(cache_id: mongo_custom_restaurants.cache_id)
        return if search_history.is_outdated_cache_id
        
        Messenger::ReplyRestaurantsFlexMessageWorker.perform_async(mongo_custom_restaurants.cache_id, page)
      end
    end
  end
end
