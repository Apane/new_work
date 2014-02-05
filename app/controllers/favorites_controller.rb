class FavoritesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @favorites = current_user.favorites.all
  end

  def toggle_favorite
    @fav_id = params[:favorite_id] # sent to js.erb
    if params[:action_type] == 'remove'
      current_user.favorites.where('favorite_id = ?', @fav_id).first.destroy
    elsif params[:action_type] == 'add'
      current_user.favorites.first_or_create(favorite_id: @fav_id)
    end
  end
end
