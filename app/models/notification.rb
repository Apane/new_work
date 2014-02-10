class Notification < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :noteable, polymorphic: true
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  after_create :push_notifications

  def push_notifications
    Pusher["new_messages_for_user_#{self.user_id}"].trigger('new_notification', {
      notification_title: "You have one new notification",
      message: "Some message here"
    })
  end
end
