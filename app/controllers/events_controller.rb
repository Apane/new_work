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
    @min_age = @event.age_min
    @max_age = @event.age_max
    # p "user age #{current_user.age} / #{current_user.gender}"
    # p "event age #{@min_age} - #{@max_age} / #{@event.gender}"
    check_event_limits

    respond_to do |format|
      format.html {redirect_to @event}
      format.js {}
    end
  end

  def check_event_limits
    if @event.is_private?
      @notice = "private"
    elsif !(@min_age..@max_age).include?(current_user.age)
      @notice = "restricted by age, only those whos age are between #{@min_age} and #{@max_age} are allowed."
    elsif @event.gender.present? && @event.gender != current_user.gender
      @notice = "restricted by gender, only #{Event::GENDER[@event.gender].downcase} are allowed."
    else
      max_attendees = @event.max_attendees.present? ? (@event.max_attendees) : 100
      @participants = @event.participants
      if @participants.size >= max_attendees
        @event_participant = @event.event_participants.create(event_id: @event.id, user_id: current_user.id, is_waiting: true)
      else
        @event_participant = @event.event_participants.create(event_id: @event.id, user_id: current_user.id)
      end
      @participant = current_user
      @waiting_participants = @event.waiting_participants
      # @event_participant = @event.event_participants.where(user_id: @participant.id).first
      @event.create_notification(current_user, 'joined')
    end
  end

  def stop_attend
    @attendees_count = @event.participants.size
    @max_attendees = @event.max_attendees.present? ? (@event.max_attendees) : 100

    @participant = @event.event_participants.where(user_id: current_user.id, event_id: @event.id).first
    @participant.destroy

    if @event.participants.size < @max_attendees
      first_waiting = @event.event_participants.where(is_waiting: true).order('id desc').first
      if first_waiting.present?
        first_waiting.update_attributes(is_waiting: false)
      end
    end

    @event.create_notification(current_user, 'left')

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
