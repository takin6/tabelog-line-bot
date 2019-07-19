module Messenger
  module Line
    class PostbackWrapper < BaseWrapper
      attr_reader :mongo_custom_restaurants_id, :page
      def post_initialize
        @mongo_custom_restaurants_id, @page = event["postback"]["data"].split("&").map { |data| data.split("=").last }
      end

      def receive
        message = Message.create_receive_message!({
          user: user,
          message_type: :postback,
          mongo_custom_restaurants_id: mongo_custom_restaurants_id,
          page: page
        })

        return message
      end

      def reply(message)
        mongo_custom_restaurants = Mongo::CustomRestaurants.find(mongo_custom_restaurants_id)
        Messenger::ReplyRestaurantsFlexMessageWorker.perform_async(mongo_custom_restaurants.search_history_id, page)
      end
    end
  end
end
