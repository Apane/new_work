class ChangeOccupationColumnInUsers < ActiveRecord::Migration
  def change
    change_column :users, :occupation, :string
  end
end
