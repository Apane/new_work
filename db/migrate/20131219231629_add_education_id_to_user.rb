class AddEducationIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :education_id, :integer
  end
end
