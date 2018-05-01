class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_user, :logged_in?
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.nil? ? false : true
  end

  def prevent_unauthorized_user_access
    redirect_to root_path, notice: 'sorry, you cannot access that page', status: :found unless logged_in?
  end

  def prevent_logged_in_user_access
    redirect_to root_path, notice: 'sorry, you cannot access that page', status: :found if logged_in?
  end
end
