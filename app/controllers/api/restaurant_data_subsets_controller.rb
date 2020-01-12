module Api
  class RestaurantDataSubsetsController < ApplicationController
    include SessionHelper

    def create_text
      params = send_chat_params
      message_line_share_button = nil

      ActiveRecord::Base.transaction do 
        restaurant_data_subset = RestaurantDataSubset.create!(
          restaurant_data_set: RestaurantDataSet.find_by(cache_id: params[:restaurant_data_set_id]),
          chat_unit: current_chat_unit,
          message_type: :text,
          selected_restaurant_ids: params[:selected_restaurant_ids]
        )

        message_line_share_button = MessageLineShareButton.create!(
          text: restaurant_data_subset.message_text,
          restaurant_data_subset: restaurant_data_subset
        )
      end

      render json: { message_text: message_line_share_button.text.html_safe }
    end

    private

    def send_chat_params
      params.require(:send_message)
            .permit(
              :restaurant_data_set_id,
              selected_restaurant_ids: []
            )
    end

  end
end