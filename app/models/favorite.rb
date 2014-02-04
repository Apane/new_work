class Favorite < ActiveRecord::Base
  has_many :favorite_relationships
  has_many :users, through: :favorite_relationships
end
