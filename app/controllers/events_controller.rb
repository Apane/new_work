class EventsController < ApplicationController
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
      @events = Event.scoped_by_search(current_user, distance, time, cat_ids, gender, ethnicity, age_min, age_max)
    else
      @events = Event.all
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
      flash[:success] = "Event updated."
      redirect_to @event
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html {redirect_to events_path}
      format.js
    end
  end

  def attend
    @event = Event.find(params[:id])
    unless @event.is_private?
      @event.event_participants.create(event_id: @event.id, user_id: current_user.id)
      @participant = current_user
      @event.create_join_notification(current_user)
    end

    respond_to do |format|
      format.html {redirect_to @event}
      format.js {}
    end
  end

  def stop_attend
    @event = Event.find(params[:id])
    @participant = @event.event_participants.where(user_id: current_user.id, event_id: @event.id).first
    @participant.destroy
    @event.create_leave_notification(current_user)

    respond_to do |format|
      format.html {redirect_to @event}
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :date, :location, :time, :location_name,
      :lng, :lat, :country, :postal_code, :state, :district, :event_type, :image)
  end
end
