module Workers
  class ReplyRestaurantsMessageBatch
    def execute(restaurant_data_subset_id, page=1)
      page = page.to_i
      restaurant_data_subset = RestaurantDataSubset.find(restaurant_data_subset_id)
      message_type = restaurant_data_subset.message_type

      # search_history = SearchHistory.find_by(cache_id: cache_id)
      # chat_unit = search_history.chat_unit
      # mongo_custom_restaurants = Mongo::CustomRestaurants.find_by(cache_id: cache_id)
      messages = []

      ActiveRecord::Base.transaction do

        message_with_text = Message.create_reply_message!({
          chat_unit: restaurant_data_subset.chat_unit,
          message_type: :text,
          message: if message_type == "carousel" 
                     restaurant_data_subset.message_carousel(page)
                   else
                     restaurant_data_subset.message_text
                   end
        }).cast
        messages.push(message_with_text)

        if message_type == "carousel"
          message_with_restaurant = Message.create_reply_message!({
            chat_unit: restaurant_data_subset.chat_unit,
            message_type: :restaurant_data_subset,
            restaurant_data_subset_id: restaurant_data_subset.id,
            page: page
          }).cast
          messages.push(message_with_restaurant)
        end
      end

      restaurant_data_subset.chat_unit.reply_to_entity(messages)
    end
  end
end
