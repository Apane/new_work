class AddOpenVisitorsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :open_visitors_at, :datetime
  end
end
