class SearchesController < ApplicationController
  before_filter :authenticate_user!

  def index
    terms = params[:search][:terms]
    @users = User.filtered(terms)
    @events = Event.where('event_date >= ?', Time.now.beginning_of_day).filtered(terms)
    @activities = Activity.where('activity_date >= ?', Time.now.beginning_of_day).filtered(terms)

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
