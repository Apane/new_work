class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def landing
    if user_signed_in?
      redirect_to profile_path
    end
  end

  def landing_welcome

  end

  def welcome

  end

end
