class SearchesController < ApplicationController
  before_filter :authenticate_user!

  def index
    terms = params[:search][:terms]
    @users = User.in_range(0..50, origin: current_user).filtered(terms)
    @events = Event.in_range(0..50, origin: current_user).where('event_date >= ?', Time.now.beginning_of_day).filtered(terms)
    @activities = Activity.in_range(0..50, origin: current_user).where('activity_date >= ?', Time.now.beginning_of_day).filtered(terms)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
