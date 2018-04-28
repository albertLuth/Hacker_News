class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    session[:user_name] = user.name
    session[:user_email] = user.email
    session[:user_uid] = user.uid
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    session[:user_uid] = nil
    session[:user_email] = nil
    redirect_to root_path
  end
end
