class Message < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :conversation
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  scope :unread, -> { where(is_new: true) }

  attr_accessible :body, :recipient_id, :conversation_id

  def new?
    self.is_new?
  end
end
