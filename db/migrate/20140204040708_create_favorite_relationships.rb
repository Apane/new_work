class CreateFavoriteRelationships < ActiveRecord::Migration
  def change
    create_table :favorite_relationships do |t|
      t.integer :favorite_id
      t.integer :user_id

      t.datetime :visited_at
    end
  end
end


