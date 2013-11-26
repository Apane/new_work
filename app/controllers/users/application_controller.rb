class Users::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

   protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password,
      :first_name, :last_name, :zip, :gender: :birthday)
    end
  end

end
