class FavoriteRelationships < ActiveRecord::Base
  # attributes are ( user_id and favourite_id )
  belongs_to :favourite
  belongs_to :user
end
