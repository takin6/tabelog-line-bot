class ApplicationController < ActionController::Base

  private

  def authenticate_user!
    session[:redirect_path_after_login] = request.url
    super
  end
end
