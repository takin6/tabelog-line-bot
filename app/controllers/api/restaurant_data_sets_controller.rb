module Api
  class RestaurantDataSetsController < ApplicationController
    include SessionHelper

    def create
      unless current_chat_unit
        # navigate to login page
        render json: { errors: "navigate to login page" }, status: :bad_request
      else
        result = Api::RestaurantDataSets::CreateUsecase.new(create_params, current_chat_unit).execute
        render json: { restaurant_data_set_id: result }, status: :created
      end
    end

    private

    def create_params
      params.require(:restaurant_data_sets)
            .permit(
              :title,
              :mongo_custom_restaurants_id,
              selected_restaurant_ids: []
            )
    end

  end
end