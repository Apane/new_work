class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
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
    @user = current_user
    @event = Event.find(params[:id])
    @comment = @event.comments.new
    @participants = @event.participants
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
     @event = Event.find(params[:id])
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
      format.html {redirect_to :back}
      format.js
    end
  end

  def attend
    @event = Event.find(params[:id])
    @event.event_participants.create(event_id: @event.id, user_id: current_user.id)
    @participant = current_user

    respond_to do |format|
      if @event.save
        format.html {redirect_to @event}
        format.js {}
      else
        format.html {redirect_to @event}
        format.js {}
      end
    end
  end

  def stop_attend
    @event = Event.find(params[:id])
    @participant = @event.event_participants.where(user_id: current_user.id, event_id: @event.id).first
    @participant.destroy

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
      :lng, :lat, :country, :postal_code, :state, :district, :event_type)
  end
end
