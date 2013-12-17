class AddEducationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :education, :string
  end
end
