class AddOccupationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :occupation, :text
  end
end
