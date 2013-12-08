class RemoveIndexFromEvents < ActiveRecord::Migration
  def change
    remove_index :events, :location
    remove_index :events, :date
  end
end
