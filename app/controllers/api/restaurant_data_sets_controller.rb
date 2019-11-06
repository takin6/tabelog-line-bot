module Api
  class RestaurantDataSetsController < ApplicationController
    include SessionHelper
    layout 'restaurants'

    def create
      unless current_chat_unit
        # navigate to login page
        render json: { errors: "navigate to login page" }, status: :bad_request
      else
        Api::RestaurantDataSets::CreateUsecase.new(create_params, current_chat_unit).execute

        head :ok
      end
    end

    private

    def create_params
      params.require(:restaurant_data_sets)
            .permit(:mongo_custom_restaurants_id, :selected_restaurant_ids)
    end

  end
end