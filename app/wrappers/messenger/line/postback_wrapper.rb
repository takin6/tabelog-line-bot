module Messenger
  module Line
    class PostbackWrapper < BaseWrapper
      attr_reader :mongo_restaurants_id, :page
      def post_initialize
        @mongo_restaurants_id, @page = event["postback"]["data"].split("&").map { |data| data.split("=").last }
      end

      def receive
        message = Message.create_receive_message!({
          user: user,
          message_type: :postback,
          mongo_restaurants_id: mongo_restaurants_id,
          page: page
        })

        return message
      end

      def reply(message)
        search_history = message.user.search_histories.last

        Messenger::ReplyRestaurantsFlexMessageWorker.perform_async(search_history.id, page)
      end
    end
  end
end
