class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource

  def update
    if params[resource_name][:password].blank?
      params[resource_name].delete(:password)
      params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank?
    end
    # Override Devise to use update_attributes instead of update_with_password.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end

  # def update
  #   # For Rails 4
  #   # account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
  #   # For Rails 3
  #   account_update_params = params[:user]

  #   # required for settings form to submit when password is left blank
  #   if account_update_params[:password].blank?
  #     account_update_params.delete("password")
  #     account_update_params.delete("password_confirmation")
  #   end

  #   @user = User.find(current_user.id)
  #   if @user.update_attributes(account_update_params)
  #     set_flash_message :notice, :updated
  #     # Sign in the user bypassing validation in case his password changed
  #     sign_in @user, :bypass => true
  #     redirect_to after_update_path_for(@user)
  #   else
  #     render "edit"
  #   end
  # end

  def account_registration
     @user = User.find(current_user.id)
  end

private

  def after_sign_up_path_for(resource)
    welcome_path
  end

  def after_update_path_for(resource)
    welcome_path
  end


end
