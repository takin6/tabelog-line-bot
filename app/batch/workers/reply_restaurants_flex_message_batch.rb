module Workers
  class ReplyRestaurantsFlexMessageBatch
    def execute(serach_history_id, page)
      page = page.to_i
      search_history = SearchHistory.find(serach_history_id)
      user = search_history.user

      mongo_restaurants = Mongo::Restaurants.find_by(station_id: search_history.station_id)
      messages = []

      ActiveRecord::Base.transaction do
        from, to = mongo_restaurants.create_index(page)
        message_with_text = Message.create_reply_message!({
          user: user, 
          message_type: :text,
          message: "📍検索結果 #{from}~#{to}/#{mongo_restaurants.restaurants.length}"
        }).cast
        messages.push(message_with_text)

        message_with_restaurant = Message.create_reply_message!({
          user: user, 
          message_type: :restaurants, 
          mongo_restaurants_id: mongo_restaurants.id.to_s,
          page: page
        }).cast
        messages.push(message_with_restaurant)
      end

      user.reply_to_user(messages)
    end
  end
end