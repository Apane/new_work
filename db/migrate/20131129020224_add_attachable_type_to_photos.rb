class AddAttachableTypeToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :attachable_type, :string
  end
end
