module Messages
  class PostBack < Message

    def create_associates(params)
      MessagePostBack.create!(
        message: self,
        mongo_restaurants_id: mongo_restaurants_id,
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.mongo_restaurants_id, self.page)
    end

  end
end
