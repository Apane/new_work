class Notification < ActiveRecord::Base
  attr_accessible :content, :user_id, :noteable_id, :noteable_type, :is_opened, :noter_id
  belongs_to :noteable, polymorphic: true
  belongs_to :user
  belongs_to :noter, class_name: 'User', foreign_key: 'noter_id'

  after_create :push_notifications

  def push_notifications
    Pusher["new_messages_for_user_#{self.user_id}"].trigger('new_notification', {
      notification_title: "You have one new notification",
      message: self.content
    })
  end

  def self.send_notification(user, noter, noteable, text)
    create(noteable_id: noteable.id,
      noteable_type: noteable.class.name,
      user_id: user.id,
      content: text.to_s,
      noter_id: noter.id)
  end

  def mark_as_read
    self.update_attributes(is_opened: true)
  end
end
