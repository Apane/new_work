class Conversation < ActiveRecord::Base
  attr_accessible :author_id, :companion_id

  has_many :messages, dependent: :destroy
  has_many :new_messages, -> { where is_new: true }, class_name: 'Message'
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'
  belongs_to :companion, class_name: 'User', foreign_key: 'companion_id'
end
