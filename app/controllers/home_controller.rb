class HomeController < ApplicationController

  def landing
    if user_signed_in?
      render landing_welcome
    else
      puts "not working"
    end
  end

  def landing_welcome

  end

end
