module Api
  class CustomRestaurantsController < ActionController::API

    def create
      mongo_custom_restaurants = Api::Restaurants::CreateUsecase.new(create_params).execute

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