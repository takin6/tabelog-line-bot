class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include SessionHelper
  include Devise::Controllers::Rememberable

  def line
    return execute
  end

  def execute
    @omniauth = request.env['omniauth.auth']
    return redirect_to root_path if @omniauth.blank?

    usecase = OmniauthCallbacks::LineUsecase.new(@omniauth)
    user = usecase.execute

    hold_chat_unit_to_session(user.chat_unit)
    sign_in user

    redirect_to session[:redirect_path_after_login] || root_path
  end

  def failure
    Rails.logger.info "failure"
    # redirect_to new_user_session_path
  end
end
