class HiddenUser < ActiveRecord::Base
  attr_accessible :hidden_user_id, :user_id

  belongs_to :user
  belongs_to :hidden_user, class_name: 'User', foreign_key: 'hidden_user_id'
end
