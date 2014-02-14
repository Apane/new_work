class AddAgeMinAndMaxToEvent < ActiveRecord::Migration
  def change
    add_column :events, :age_min, :integer, default: 18
    add_column :events, :age_max, :integer, default: 80
  end
end
