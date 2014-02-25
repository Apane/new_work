class AddProfilePhotoToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :profile_photo, :boolean, default: false
  end
end
