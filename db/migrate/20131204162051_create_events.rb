class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :date
      t.string :location
      t.string :gps_location
      t.references :user, index: true

      t.timestamps
    end
    add_index :events, :location, :unique => true
    add_index :events, :date, :unique => true
  end
end
