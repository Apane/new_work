class HomeController < ApplicationController
  before_filter :authenticate_user!, except: [:landing]

  def landing
    if user_signed_in?
      redirect_to welcome_path
    else
      render layout: 'home_page'
    end
  end

  def welcome
    @user = current_user
    @questions_for_about = @user.questions.for_about.order('id asc')
    # @questions_for_personality = @user.questions.for_personality.order('id asc')
    @events = current_user.events
    @activities = current_user.activities

    json = JSON.parse(current_user.preferences)
    @books = json['books']
    @movies = json['movies']
    @blogs= json['blogs']
    @websites = json['websites']
    @people = json['people']
    @things = json['things']
    @pref_activities = json['activities']
    @values = json['values']
    @pets = json['pets']
  end
end
