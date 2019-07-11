module Messenger
  module Line
    class PostbackWrapper
      attr_reader :user, :event
      def initialize(user, event)
        @user = user
        @event = event
      end

      def receive
        mongo_restaurants_id, current_page = event["data"].split("&").map { |data| data.split("=").last }
        mongo_restaurants = Mongo::Restaurants.find(mongo_restaurants_id)

        next_from, next_to = mongo_restaurants.create_index(current_pager + 1)
        message_with_text = Message.create_reply_message!({
          user: user, 
          message_type: :text,
          message: "📍検索結果 #{next_from}~#{next_to}/#{mongo_restaurants.length}"
        }).cast
        messages.push(message_with_text)

        message = Message.create_reply_message!({
          user: user, 
          message_type: :postback,
          mongo_restaurants_id: mongo_restaurants_id,
          page: mongo_restaurants.next_page(current_page)
        })
        messages.push(message_with_restaurant)

        user.reply_to_user(messages)
      end
    end
  end
end
