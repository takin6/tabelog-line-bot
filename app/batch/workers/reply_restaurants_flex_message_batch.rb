module Workers
  class ReplyRestaurantsFlexMessageBatch
    def execute(serach_history_id, pager)
      search_history = SearchHistory.find(serach_history_id)
      user = search_history.user

      mongo_restaurants = Mongo::Restaurants.find_by(station_id: search_history.station_id)
      messages = []

      ActiveRecord::Base.transaction do
        message_with_text = Message.create_reply_message!({
          user: user, 
          message_type: :text,
          message: "📍検索結果 1~8/#{mongo_restaurans.retaurants.length}"
        }).cast
        messages.push(message_with_text)

        message_with_restaurant = Message.create_reply_message!({
          user: user, 
          message_type: :restaurants, 
          mongo_restaurants_id: mongo_restaurants.id.to_s,
          pager: pager
        }).cast
        messages.push(message_with_restaurant)
      end

      user.reply_to_user(messages)
    end
  end
end