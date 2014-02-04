class FavoriteRelationship < ActiveRecord::Base
  # attributes are ( user_id and favourite_id )
  belongs_to :favorite
  belongs_to :user
end
