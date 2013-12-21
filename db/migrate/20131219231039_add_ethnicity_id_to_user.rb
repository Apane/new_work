class AddEthnicityIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :ethnicity_id, :integer
  end
end
