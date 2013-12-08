class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in(:user, user)
    session[:user_id] = user.id

    redirect_to welcome_path
  end
end
