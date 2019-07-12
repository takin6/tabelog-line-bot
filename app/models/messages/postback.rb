module Messages
  class Postback < Message

    def create_associates(params)
      MessagePostback.create!(
        message: self,
        mongo_restaurants_id: params[:mongo_restaurants_id],
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.mongo_restaurants_id, self.page)
    end

  end
end
