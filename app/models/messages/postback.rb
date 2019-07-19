module Messages
  class Postback < Message

    def create_associates(params)
      MessagePostback.create!(
        message: self,
        mongo_custom_restaurants_id: params[:mongo_custom_restaurants_id],
        page: params[:page]
      )
    end

    def line_post_param
      Messenger::RestaurantsFlexMessageValue.new(self.postback_mongo_custom_restaurants_id, self.postback_page)
    end

  end
end
