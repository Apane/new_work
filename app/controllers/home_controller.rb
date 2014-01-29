class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def landing
    if user_signed_in?
      redirect_to welcome_path
    end

    render layout: 'home_page'
  end

  def welcome
    @user = current_user
    @questions_for_about = @user.questions.for_about.order('id asc')
    @questions_for_personality = @user.questions.for_personality.order('id asc')
  end
end
