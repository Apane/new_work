class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_interesting_people

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :current_password,
               :first_name, :last_name, :zip, :birthday, :gender, :occupation, :address, :interests, :aboutme, :profile_image)
    end
  end

  def set_interesting_people
    @interesting_people = User.order("random()").first(5)
  end

end
