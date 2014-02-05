class BlockedUser < ActiveRecord::Base
  attr_accessible :blocked_user_id, :user_id

  belongs_to :user
  belongs_to :blocked_user, class_name: 'User', foreign_key: 'blocked_user_id'
end
