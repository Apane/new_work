class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:search]
      @terms = params[:search][:terms] || nil
      @min_age = params[:search][:min_age] || nil
      @max_age = params[:search][:max_age] || nil
      @zipcode = params[:search][:zipcode] || nil
      @distance = params[:search][:distance] || nil
      @education_id = params[:search][:education_id] || nil
      @ethnicity_id = params[:search][:ethnicity_id] || nil
      @gender = params[:search][:gender] || nil
      @users = User.scoped_by_search(@terms, @min_age, @max_age, @education_id, @ethnicity_id, @gender)
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id]) || User.find(current_user.id)
    @questions_for_about = @user.questions.for_about.order('id asc')
    @questions_for_personality = @user.questions.for_personality.order('id asc')
    @user.visits.where(visitor: current_user).first_or_create
  end
end
