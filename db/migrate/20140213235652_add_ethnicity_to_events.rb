class AddEthnicityToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ethnicity_id, :integer
  end
end
