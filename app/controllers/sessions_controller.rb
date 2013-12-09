class SessionsController < ApplicationController
  def create
    if user_signed_in?
      user = current_user.update_from_omniauth(env["omniauth.auth"])
    else
      user = User.where('uid = ? or email = ?', env["omniauth.auth"]['uid'], env["omniauth.auth"]['info']['email']).first
      if user.present?
        user.update_from_omniauth(env["omniauth.auth"])
        sign_in(:user, user)
        session[:user_id] = user.id
      else
        user = User.from_omniauth(env["omniauth.auth"])
        sign_in(:user, user)
        session[:user_id] = user.id
      end
    end

    redirect_to welcome_path
  end
end
