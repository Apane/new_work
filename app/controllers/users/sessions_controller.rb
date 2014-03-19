class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
    resource.activate_account if resource.disabled?
  end

  private

  def after_sign_in_path_for(resource)
    if user_signed_in?
      welcome_path
    else
      flash[:notice] = "Something went wrong"
      new_user_registration_path
    end
  end


end
