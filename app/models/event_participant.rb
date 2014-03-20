class EventParticipant < ActiveRecord::Base
  attr_accessible :user_id, :event_id, :is_waiting

  belongs_to :user
  belongs_to :event
  has_many :notifications, as: :noteable

  validates :user_id, uniqueness: {scope: :event_id}

  after_create :notify_owner

  def notify_owner # owner gets email when new participant joins to event
    UserMailer.new_participant(self).deliver if self.event.user.accepts_email_for_new_participant?
  end
end
