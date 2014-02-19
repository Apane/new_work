class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true
      t.string :title
      t.text :description
      t.string :location
      t.date :date
      t.string :time
      t.datetime :activity_date
      t.float :lat
      t.float :lng
      t.string :location
      t.string :location_name
      t.boolean :activity_type
      t.string :postal_code
      t.string :country
      t.string :state
      t.string :city
      t.string :district
      t.integer :frequency_id
      t.integer :category_id
      t.integer :gender, default: 0
      t.integer :ethnicity_id
      t.integer :age_min, default: 18
      t.integer :age_max, default: 80

      t.timestamps
    end
  end
end
