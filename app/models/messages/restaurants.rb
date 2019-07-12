module Messages
  class Restaurants < Message

    def create_associates(params)
      MessageRestaurant.create!(
        message: self,
        mongo_restaurants_id: params[:mongo_restaurants_id],
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.message_restaurant_mongo_restaurants_id, self.message_restaurant_page).line_post_param
    end
  end
end