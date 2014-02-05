class Favorite < ActiveRecord::Base
  attr_accessible :favorite_id, :user_id

  belongs_to :user
  belongs_to :favorited, class_name: 'User', foreign_key: 'favorite_id'
end
