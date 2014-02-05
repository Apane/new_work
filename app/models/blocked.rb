class Blocked < ActiveRecord::Base
  attr_accessible :blocked_id, :user_id

  belongs_to :user
  belongs_to :blocked, class_name: 'User', foreign_key: 'blocked_id'
end
