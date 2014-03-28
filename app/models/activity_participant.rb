class ActivityParticipant < ActiveRecord::Base
  attr_accessible :activity_id, :user_id
  belongs_to :user
  belongs_to :activity

  after_create :notify_owner

  def notify_owner # owner gets email when new participant joins to event
    UserMailer.new_activity_participant(self).deliver if self.activity.user.accepts_email_for_new_participant?
  end
end
