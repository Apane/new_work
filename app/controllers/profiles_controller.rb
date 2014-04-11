class ProfilesController < ApplicationController
  before_filter :authenticate_user!

  def index
    if params[:search]
      @users = User.active.scoped_by_search(params[:search]).where.not(id: current_user.id)
    else
      @users = User.active.where.not(id: current_user.id).page params[:page]
    end
  end

  def show
    @user = User.active.where(id: params[:id]).first

    json = JSON.parse(@user.preferences)
    @books = json['books']
    @movies = json['movies']
    @blogs= json['blogs']
    @websites = json['websites']
    @people = json['people']
    @things = json['things']
    @pref_activities = json['activities']
    @values = json['values']
    @pets = json['pets']

    if @user.present?
      @questions_for_about = @user.questions.for_about.order('id asc')
      @user.create_visit(current_user)
    else
      redirect_to profiles_path, notice: 'User not found or account disabled'
    end
  end
end
