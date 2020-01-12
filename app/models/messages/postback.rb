module Messages
  class Postback < Message

    def create_associates(params)
      MessagePostback.create!(
        message: self,
        restaurant_data_subset_id: params[:restaurant_data_subset_id],
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.postback_restaurant_data_subset_id, self.postback_page)
    end

  end
end
