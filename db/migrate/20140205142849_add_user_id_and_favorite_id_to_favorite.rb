class AddUserIdAndFavoriteIdToFavorite < ActiveRecord::Migration
  def change
    add_column :favorites, :user_id, :integer
    add_column :favorites, :favorite_id, :integer
  end
end
