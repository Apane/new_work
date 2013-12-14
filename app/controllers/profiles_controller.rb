class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:search]
      terms = params[:search][:terms]
      @users = User.scoped_by_search(terms)
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id]) || User.find(current_user.id)
    @questions_for_about = @user.questions.for_about.order('id asc')
    @questions_for_personality = @user.questions.for_personality.order('id asc')
  end
end
