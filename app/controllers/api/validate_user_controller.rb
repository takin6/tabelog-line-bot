module Api
  class ValidateUserController < ActionController::API
    include SessionHelper

    def create
      user = User.find_or_create_by(
        line_id: validate_user_param[:line_id], 
        name: validate_user_param[:name], 
        profile_picture_url: validate_user_param[:profile_picture_url]
      )

      hold_session(user)
      if current_user
        head :ok
      else
        head :bad_request
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