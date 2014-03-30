class AddNoterIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :noter_id, :integer
  end
end
