module Api
  class RestaurantDataSetsController < ApplicationController
    include SessionHelper
    before_action :get_restaurant_data_set, action: [:delete]

    def create
      unless current_chat_unit
        # navigate to login page
        render json: { errors: "navigate to login page" }, status: :bad_request
      else
        result = Api::RestaurantDataSets::CreateUsecase.new(create_params, current_chat_unit).execute
        render json: { restaurant_data_set_id: result }, status: :created
      end
    end

    def destroy
      unless current_chat_unit
        render json: { errors: "navigate to login page"}, status: :bad_request
      else
        unless @restaurant_data_set
          render json: { errors: "invalid restaurant_data_set"}, status: :bad_request
        else
          @restaurant_data_set.delete
          head :ok
        end
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

    def get_restaurant_data_set
      @restaurant_data_set = RestaurantDataSet.find_by(cache_id: params[:id])
    end

  end
end