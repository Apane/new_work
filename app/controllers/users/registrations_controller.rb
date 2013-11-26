class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource

  def after_sign_up_path_for(resource)
    welcome_path
  end

end
