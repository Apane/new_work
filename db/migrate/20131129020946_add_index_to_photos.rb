class AddIndexToPhotos < ActiveRecord::Migration
  def self.up
    add_index :photos, :attachable_type, :name => 'index_photos_on_attachable_type'
  end

  def self.down
    remove_index :photos, 'index_photos_on_attachable_type'
  end

end
