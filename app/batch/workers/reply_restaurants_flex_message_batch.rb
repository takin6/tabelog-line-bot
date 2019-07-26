module Workers
  class ReplyRestaurantsFlexMessageBatch
    def execute(serach_history_id, page)
      page = page.to_i
      search_history = SearchHistory.find(serach_history_id)
      user = search_history.user

      mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(search_history_id: search_history.id)
      messages = []

      ActiveRecord::Base.transaction do
        from, to = mongo_custom_restaurants.create_index(page)
        message_with_text = Message.create_reply_message!({
          user: user,
          message_type: :text,
          message: "📍検索結果 #{from}~#{to}/#{mongo_custom_restaurants.restaurants.length}"
        }).cast
        messages.push(message_with_text)

        message_with_restaurant = Message.create_reply_message!({
          user: user, 
          message_type: :restaurants, 
          mongo_custom_restaurants_id: mongo_custom_restaurants.id.to_s,
          page: page
        }).cast
        messages.push(message_with_restaurant)
      end

      user.reply_to_user(messages)
    end
  end
end