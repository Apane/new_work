class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource

  def update
    # For Rails 4
    # account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    # For Rails 3
    account_update_params = params[:user]

    # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

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
