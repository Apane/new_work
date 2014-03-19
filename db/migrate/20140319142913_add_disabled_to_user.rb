class AddDisabledToUser < ActiveRecord::Migration
  def change
    add_column :users, :disabled_at, :datetime
  end
end
