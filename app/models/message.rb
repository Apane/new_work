class Message < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :conversation
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  scope :unread, -> { where(is_new: true) }

  attr_accessible :body, :recipient_id, :conversation_id

  after_create :push_notifications

  def push_notifications
    Pusher["new_messages_for_user_#{self.recipient_id}"].trigger('new_message', {
      # message: truncate(self.body, :length => 150),
      message_title: 'New message',
      new_messages_count: self.recipient.inbox_messages.unread.count,
      message: "<a href='/messages/#{self.conversation_id}'>You have a new message from #{self.sender.name}</a>".html_safe
    })
    Pusher["new_messages_in_conversation_#{self.conversation_id}"].trigger('add_message_to_conversation', {
      conversation_id: self.conversation_id
    })
  end

  def new?
    self.is_new?
  end

  def owner_is?(user)
    self.sender_id == user.id
  end
end
