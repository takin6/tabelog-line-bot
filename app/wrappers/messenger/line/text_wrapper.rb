module Messenger
  module Line
    class TextWrapper < BaseWrapper
      attr_reader :user, :text
      def post_initialize
        @text = event.message['text']
      end

      def validate
        result = ValidateReceivedMessagePolicy.new(user, text).check

        return result if result.present?
      end

      def reply_error_messages(message_params)
        # どんなメッセージを送ってきたのかの履歴を見れる用
        ActiveRecord::Base.transaction do
          Message.create_receive_message!({ message_type: "text", user: user, message: text })
          message_params.each do |param|
            message = Message.create_reply_message!(param)
            Messenger::ReplyErrorMessageWorker.perform_async(user.id, message.id)
          end
        end
      end

      def receive
        # ここはmessage_search_history的な感じにした方が良いのかなーーーー？
        received_message = Message.create_receive_message!({ message_type: "text", user: user, message: text  })
        SearchHistory.create_from_message(user.id, text)

        return received_message
      end

      def reply(message)
        search_history = message.user.search_histories.last

        # other_requestsでも絞り込めるように
        SearchRestaurantWorker.perform_async user.id if Mongo::Restaurants.where(station_id: search_history.station_id).count == 0

        if Mongo::Restaurants.where(station_id: search_history.station_id).count == 0
          message_params = [{ message_type: "text", user: user, message: "レストランが一件も検索されませんでした。" }]
          reply_error_messages(message_params)

          return
        else
          search_history.completed = true
          search_history.save!
        end

        Messenger::ReplyRestaurantsFlexMessageWorker.perform_async search_history.id
      end

    end
  end
end
