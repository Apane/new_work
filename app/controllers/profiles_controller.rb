class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:search]
      terms = params[:search][:terms] || nil
      min_age = params[:search][:age_min] || nil
      max_age = params[:search][:age_max] || nil
      zipcode = params[:search][:zipcode] || nil
      distance = params[:search][:distance] || nil
      education_id = params[:search][:education_id] || nil
      # @ethnicity_id = params[:search][:ethnicity_id] || nil
      ethnicity_ids = params[:search][:cat_ids].split('').uniq || nil
      gender = params[:search][:gender] || nil
      @users = User.scoped_by_search(terms, min_age, max_age, education_id, ethnicity_ids, gender)
    else
      @users = User.page(params[:page]).per_page(5)
    end
  end

  def show
    @user = User.find(params[:id])
    @questions_for_about = @user.questions.for_about.order('id asc')
    @questions_for_personality = @user.questions.for_personality.order('id asc')
    visit = @user.visits.where(visitor: current_user).first
    if visit.present?
      visit.visited_at = Time.now
      visit.save
    else
      @user.visits.create(visitor_id: current_user.id)
    end
  end
end
