class AddUserIdToEducation < ActiveRecord::Migration
  def change
    add_column :educations, :user_id, :integer
  end
end
