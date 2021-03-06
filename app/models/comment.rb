class Comment < ActiveRecord::Base
  attr_accessible :title, :body, :subject, :user_id

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]

  validates :body, :presence => true
  validates :user, :presence => true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, :polymorphic => true
  has_many :notifications, as: :noteable

  # NOTE: Comments belong to a user
  belongs_to :user

  after_create :create_notification, :push_notifications

  def push_notifications
    if self.commentable_type == 'Event'
      Pusher["notifications_for_event_#{self.commentable_id}"].trigger('new_comment', {
        user_id: self.user_id,
        message_title: 'New comment',
        message: "<a href='/events/#{self.commentable_id}'>#{self.user.username} commented on #{self.commentable.title} event </a>".html_safe
      })
    end
  end

  def create_notification
    owner = self.commentable.user
    user = self.user
    participants = self.commentable.participants.where('user_id <> ?', self.user_id)
    Notification.prepare_notification(participants, user, self, "#{user.username} commented on #{self.commentable.title} #{self.commentable_type.downcase}!")
    UserMailer.new_comment(self, owner).deliver if owner.accepts_email_for_new_comment?
  end

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new \
      :commentable => obj,
      :body        => comment,
      :user_id     => user_id
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
end
