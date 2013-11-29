class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :file
      t.references :attachable, index: true

      t.timestamps
    end
  end
end
