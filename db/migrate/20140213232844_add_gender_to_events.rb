class AddGenderToEvents < ActiveRecord::Migration
  def change
    add_column :events, :gender, :integer, default: 0
  end
end
