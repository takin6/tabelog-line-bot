class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery with: :null_session

  include SessionHelper
  include Devise::Controllers::Rememberable

  def line
    return execute
  end

  def failure
    Rails.logger.info "failure"
    # redirect_to new_user_session_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def execute
    @omniauth = request.env['omniauth.auth']
    return redirect_to root_path if @omniauth.blank?

    usecase = OmniauthCallbacks::LineUsecase.new(@omniauth)
    chat_unit = usecase.execute

    hold_chat_unit_to_session(chat_unit)
    sign_in chat_unit.user

    redirect_to session[:redirect_path_after_login] || root_path
  end
end
