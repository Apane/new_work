class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :attend, :stop_attend, :report]

  # GET /activities
  # GET /activities.json
  def index
    @user = current_user

    if params[:search]
      @activities = Activity.scoped_by_search(current_user, params[:search])
    else
      @activities = Activity.all #.where('activity_date >= ?', Time.now.beginning_of_day)
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
    if @activity.present?
      @user = current_user
      # @event = Event.find(params[:id])
      @owner = @activity.user
      @participants = @activity.participants
    else
      redirect_to events_path, error: 'Event not found'
    end
  end

  # GET /activities/new
  def new
    @activity = current_user.activities.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @activity = current_user.activities.new(activity_params)
    if @activity.save
      redirect_to @activity, notice: 'Activity was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url }
    end
  end

  def attend
    @min_age = @activity.age_min
    @max_age = @activity.age_max
    res = @activity.attend(current_user)
    @notice = res[0]

    respond_to do |format|
      format.html {redirect_to @activity}
      format.js {}
    end
  end

  def stop_attend
    @participant = @activity.activity_participants.where(user_id: current_user.id, activity_id: @activity.id).first
    @participant.destroy

    respond_to do |format|
      format.html {redirect_to @activity}
      format.js
    end
  end

  def report
    @activity.reports.create(user_id: current_user.id)
    redirect_to :back, notice: ' Activity has been reported! The administration will be notified.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:title, :description, :location, :date, :time, :activity_date,
        :lat, :lng, :location, :location_name, :activity_type, :postal_code, :country, :state, :city,
        :frequency_id, :category_id, :gender, :ethnicity_id, :age_min, :age_max, :ages, :district, :image,
        :remove_image)
    end
end
