class AddGmapsAttributesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lat, :float
    add_column :events, :lng, :float
    add_column :events, :location_name, :string
    add_column :events, :event_type, :boolean, default: false
    add_column :events, :max_attendees, :integer
    add_column :events, :postal_code, :string
    add_column :events, :country, :string
    add_column :events, :state, :string
    add_column :events, :district, :string
  end
end
