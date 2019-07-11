module Messages
  class Restaurants < Message

    def create_associates(params)
      MessageRestaurant.create!(
        message: self,
        mongo_restaurants_id: params[:mongo_restaurants_id],
        pager: params[:pager]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.mongo_restaurants_id, self.pager).line_post_param
    end
  end
end