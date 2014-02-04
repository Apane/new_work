class FavoritesController < ApplicationController
 before_filter :find_user

  def index
    @favorites = @user.favorites
  end

  def create
    @user = User.find params[:id]
    @user.favorites << @user
  def

  def destroy
    @favorite = @user.favorites.find_by_user_id params[:id]
    @favorite.destroy unless @favorite.blank?
  end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  end

end
