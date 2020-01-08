module Api
  class CustomRestaurantsController < ActionController::API

    def create
      result = Api::Restaurants::CreateUsecase.new(create_params).execute

      if result.try(:error).present?
        render json: { errors: result.error }, status: :not_found
      else
        render json: { mongo_custom_restaurants: result }
      end
    end

    private

    def create_params
      params.require(:line_liff)
            .permit(
              :meal_type,
              location: %i[id type],
              genre: [
                :custom_input,
                master_genres: []
              ],
              budget: %i[lower upper]
            )
    end
  end
end