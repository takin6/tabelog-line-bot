module Messages
  class Restaurants < Message

    def create_associates(params)
      MessageRestaurant.create!(
        message: self,
        mongo_custom_restaurants_id: params[:mongo_custom_restaurants_id],
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.restaurant_mongo_custom_restaurants_id, self.restaurant_page).line_post_param
    end
  end
end