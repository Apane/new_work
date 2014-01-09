class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :author_id
      t.integer :companion_id

      t.timestamps
    end
  end
end
