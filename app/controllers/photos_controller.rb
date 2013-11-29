class PhotosController < ApplicationController
  def new
  end

  def create
    @photo = current_user.photos.create(params[:photo])
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  #not needed with protected_attributes gem
  #def photo_params
  #  params.require(:photo).permit(:file, :attachable_id, :attachable_type, :image)
  #end
end
