class DropTableFavoriteRelashionship < ActiveRecord::Migration
  def change
    drop_table :favorite_relationships
  end
end
