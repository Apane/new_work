class EventParticipant < ActiveRecord::Base
  attr_accessible :user_id, :event_id, :is_waiting

  belongs_to :user
  belongs_to :event
  has_many :notifications, as: :noteable

  validates :user_id, uniqueness: {scope: :event_id}

  after_create :notify_owner

  def notify_owner # owner gets email when new participant joins to event
    event = self.event
    owner = event.user
    participant = self.user
    title = event.title
    class_name = 'Event'

    if self.user_id != event.user_id #do not send to event owner when self join after event is created
      UserMailer.new_participant(owner, participant, title, class_name).deliver if event.user.accepts_email_for_new_participant?
    end
  end

  def remove_and_update_queue(event, max_attendees)
    self.destroy
    if event.participants.size < max_attendees
      first_waiting = event.event_participants.where(is_waiting: true).order('id desc').first
      first_waiting.update_attributes(is_waiting: false) if first_waiting.present?
    end
  end
end
