class Notification < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :noteable, polymorphic: true

  after_create :push_notifications

  def push_notifications
    Pusher["new_messages_for_user_#{self.user_id}"].trigger('new_notification', {
      # user_id: self.user_id
      # message_title: 'New comment'
      #message: "<a href='/events/#{self.commentable_id}'>#{self.user.name} commented on #{self.commentable.title} event </a>".html_safe
    })
  end
end
