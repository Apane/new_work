class FavoritesController < ApplicationController
 before_filter :find_user

  def index
    @favorites = @user.favorites
  end

  def create
    @currentuser = current_user
    @user = User.find params[:id]
    @currentuser.favorites << @user
  end

  def destroy
    @favorite = @user.favorites.find_by_user_id params[:id]
    @favorite.destroy unless @favorite.blank?
  end

  def find_user
    @user = current_user
  end

end
