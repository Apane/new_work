class RemoveEducationFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :education, :string
  end
end
