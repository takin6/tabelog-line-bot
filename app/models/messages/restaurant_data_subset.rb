module Messages
  class RestaurantDataSubset < Message

    def create_associates(params)
      MessageRestaurantDataSubset.create!(
        message: self,
        restaurant_data_subset_id:  params[:restaurant_data_subset_id],
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(
        self.message_restaurant_data_subset.restaurant_data_subset_id, 
        self.message_restaurant_data_subset.page
      ).line_post_param
    end
  end
end