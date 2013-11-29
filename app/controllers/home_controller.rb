class HomeController < ApplicationController

  def landing
    if user_signed_in?
      render profile_path
    else
      puts ""
    end
  end

  def landing_welcome

  end

  def welcome

  end

end
