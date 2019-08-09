module Workers
  class ReplyRestaurantsFlexMessageBatch
    def execute(cache_id, page)
      page = page.to_i
      search_history = SearchHistory.find_by(cache_id: cache_id)
      chat_unit = search_history.chat_unit
      mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: cache_id)
      messages = []

      ActiveRecord::Base.transaction do

        message_with_text = Message.create_reply_message!({
          chat_unit: chat_unit,
          message_type: :text,
          message: search_history.search_result_message(page)
        }).cast
        messages.push(message_with_text)

        message_with_restaurant = Message.create_reply_message!({
          chat_unit: chat_unit, 
          message_type: :restaurants, 
          mongo_custom_restaurants_id: mongo_custom_restaurants.id.to_s,
          page: page
        }).cast
        messages.push(message_with_restaurant)
      end

      chat_unit.reply_to_entity(messages)
    end
  end
end