class CreateHiddenUsers < ActiveRecord::Migration
  def change
    create_table :hidden_users do |t|
      t.integer :user_id
      t.integer :hidden_user_id

      t.timestamps
    end
  end
end
