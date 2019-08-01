module Api
  class ValidateUserController < ActionController::API
    include SessionHelper

    def create
      user = User.find_by(
        line_id: validate_user_param[:line_id], 
        name: validate_user_param[:name], 
        profile_picture_url: validate_user_param[:profile_picture_url]
      )

      hold_session(user)
      unless current_user&.is_blocked?
        head :ok
      else
        message = current_user ? "ブロックを解除してから検索してください" : "無効なセッションです"
        render json: { errors: message }, status: :bad_request
      end
    end

    private

    def validate_user_param
      params.require(:user)
            .permit(
              :line_id,
              :name,
              :profile_picture_url
            )
    end
  end
end