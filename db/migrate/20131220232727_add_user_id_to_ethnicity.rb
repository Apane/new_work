class AddUserIdToEthnicity < ActiveRecord::Migration
  def change
    add_column :ethnicities, :user_id, :integer
  end
end
