class ActivityParticipant < ActiveRecord::Base
  attr_accessible :activity_id, :user_id
  belongs_to :user
  belongs_to :activity

  after_create :notify_owner

  def notify_owner # owner gets email when new participant joins to event
    activity = self.activity
    if self.user_id != activity.user_id #do not send to event owner when self join after event is created
      UserMailer.new_activity_participant(self).deliver if activity.user.accepts_email_for_new_participant?
    end
  end
end
