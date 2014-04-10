class EventsController < ApplicationController
  before_filter :set_event, only: [:report, :destroy, :attend, :stop_attend]
  before_filter :authenticate_user!

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
      @events = Event.where('event_date >= ?', Time.now.beginning_of_day).scoped_by_search(current_user, distance, time, cat_ids, gender, ethnicity, age_min, age_max)
    else
      #@events = Event.where('event_date > ?', DateTime.now)
      @events = Event.where('event_date >= ?', Time.now.beginning_of_day)
      # @events = Event.all
    end

    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def show
    @event = Event.where(id: params[:id]).first
    if @event.present?
      @user = current_user
      # @event = Event.find(params[:id])
      @owner = @event.user
      @participants = @event.participants
      @waiting_participants = @event.waiting_participants
    else
      redirect_to events_path, error: 'Event not found'
    end
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
     @event = current_user.events.find(params[:id])
    if @event.update_attributes(params[:event])
      @event.update_event_date
      flash[:success] = "Event updated."
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @event.destroy

    respond_to do |format|
      format.html {redirect_to events_path}
      format.js
    end
  end

  def attend
    @participant = current_user
    res = @event.attend(current_user)
    @event_participant= res[0]
    @participants = res[1]
    @waiting_participants = res[2]
    @notice = res[3]

    respond_to do |format|
      format.html {redirect_to @event}
      format.js {}
    end
  end

  def stop_attend
    @participant = @event.stop_attend(current_user)

    respond_to do |format|
      format.html {redirect_to @event}
      format.js
    end
  end

  def report
    @event.reports.create(user_id: current_user.id)
    redirect_to :back, notice: ' Event has been reported! The administration will be notified.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :date, :location, :time, :location_name,
      :lng, :lat, :country, :postal_code, :state, :district, :event_type, :image, :remove_image)
  end
end
