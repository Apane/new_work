class Users::SessionsController < Devise::SessionsController


  private

  def after_sign_in_path_for(resource)
    if user_signed_in?
      welcome_path
    else
      new_user_registration_path
    end
  end


end
