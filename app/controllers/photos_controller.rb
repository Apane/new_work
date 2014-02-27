class PhotosController < ApplicationController
  before_filter :authenticate_user!

  def new
  end

  def create
    @photo = current_user.photos.create(params[:photo])
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    @photo.destroy
  end

  def update
     @user = User.find(params[:id])
     @photo = current_user.photos.find(params[:id])
    if @photo.update_attributes(params[:photo])
       @photo.save
      flash[:success] = "Photo updated."
      redirect_to @user
    else
      flash[:error] = "Photo didnt update."
    end
  end

  def add_as_profile
    @photo = current_user.photos.find(params[:id])
    if @photo.present?
      current_profile_pic = current_user.profile_photo
      if current_profile_pic.present?
        current_profile_pic.update_attributes(profile_photo: false)
      end

      @photo.update_attributes(profile_photo: true)
      notice = 'Profile picture updated'
    else
      notice = 'Photo not found!'
    end

    redirect_to :back, notice: notice
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  #not needed with protected_attributes gem
  #def photo_params
  #  params.require(:photo).permit(:file, :attachable_id, :attachable_type, :image)
  #end
end
