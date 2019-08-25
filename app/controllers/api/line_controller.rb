module Api
  class LineController < ActionController::API
    include SessionHelper

    def callback
      result = Api::Line::ReceiveUsecase.new.receive(request)

      if result.success
        head :ok
      else
        head :bad_request
      end
    end

    def callback_liff
      head :bad_request unless current_chat_unit
      result = Api::Line::Liff::ReceiveUsecase.new(current_chat_unit, callback_liff_params).execute

      if result.success
        head :ok
      else
        render json: { errors: result.error }, status: :unprocessable_entity
      end

    end

    private

    def callback_liff_params
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
