class FavoritesController < ApplicationController
 before_filter :find_user

  def index
    @favorites = Favorite.all
  end

  def new
    @favorite = Favorite.new
  end

  def create
     @favorite = current_user.favorites.new(favorite_params)

      respond_to do |format|
      if @favorite.save
        format.html { redirect_to @favorite, notice: 'Favorite was successfully added.' }
        format.json { render action: 'show', status: :created, location: @favorite }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @favorite.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def show
    @favorite = Favorite.where(id: params[:id]).first
    if @Ffavorite.present?
      @user = current_user
      # @event = Event.find(params[:id])
      @favorites = @favorite.users
    else
      redirect_to favorites_path, error: 'Favorite not found'
    end
  end

  def destroy
    @favorite = @user.favorites.find_by_user_id params[:id]
    @favorite.destroy unless @favorite.blank?
  end

  def find_user
    @user = current_user
  end

 private
  # Use callbacks to share common setup or constraints between actions.
  def set_favorite
    @favorite = Favorite.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def favorite_params
    params.require(:favorite).permit(:user_id)
  end

end
