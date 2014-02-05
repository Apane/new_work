class CreateHiddens < ActiveRecord::Migration
  def change
    create_table :hiddens do |t|
      t.integer :user_id
      t.integer :hidden_id

      t.timestamps
    end
  end
end
