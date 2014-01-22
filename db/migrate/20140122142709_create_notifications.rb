class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :noteable_id
      t.string :noteable_type
      t.string :content
      t.integer :user_id
      t.boolean :is_opened, default: false

      t.timestamps
    end
  end
end
