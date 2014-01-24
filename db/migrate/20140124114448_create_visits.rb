class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.integer :visitor_id
      t.datetime :visited_at

      t.timestamps
    end
  end
end
