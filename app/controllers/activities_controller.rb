class ActivitiesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :attend, :stop_attend, :report]

  # GET /activities
  # GET /activities.json
  def index
    @user = current_user

    if params[:search]
      distance = params[:search][:distance] || nil
      time = params[:search][:time] || nil
      cat_ids = params[:search][:cat_ids].split('').uniq || nil
      gender = params[:search][:gen] || nil
      ethnicity = params[:search][:ethn] || nil
      age_min = params[:search][:age_min] || nil
      age_max = params[:search][:age_max] || nil
      @activities = Activity.scoped_by_search(current_user, distance, time, cat_ids, gender, ethnicity, age_min, age_max)
    else
      #@events = Event.where('event_date > ?', DateTime.now)
      @activities = Activity.all
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

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render action: 'show', status: :created, location: @activity }
      else
        p @activity.errors
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url }
      format.json { head :no_content }
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
