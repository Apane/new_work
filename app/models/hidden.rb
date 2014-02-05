class Hidden < ActiveRecord::Base
  attr_accessible :hidden_id, :user_id

  belongs_to :user
  belongs_to :hidden, class_name: 'User', foreign_key: 'hidden_id'
end
