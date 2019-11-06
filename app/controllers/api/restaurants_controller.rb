module Api
  class RestaurantsController < ActionController::API

    def create
      # とりあえずchat_unitはあるものとする
      current_chat_unit = User.second.chat_unit
      mongo_custom_restaurants = Api::Restaurants::CreateUsecase.new(current_chat_unit, create_params).execute

      render json: { mongo_custom_restaurants: mongo_custom_restaurants }
    end

    private

    def create_params
      params.require(:line_liff)
            .permit(
              :location, :meal_type,
              genre: [
                :custom_input,
                master_genres: []
              ],
              budget: %i[lower upper]
            )
    end
  end
end