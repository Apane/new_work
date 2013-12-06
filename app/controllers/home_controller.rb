class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def landing
    if user_signed_in?
      redirect_to profile_path
    end
  end

  def landing_welcome
    @questions_for_about = current_user.questions.for_about.order('id asc')
    @questions_for_personality = current_user.questions.for_personality.order('id asc')
  end

  def welcome

  end

end
