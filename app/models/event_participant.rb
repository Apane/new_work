class EventParticipant < ActiveRecord::Base
  attr_accessible :user_id, :event_id

  belongs_to :user
  belongs_to :event
  has_many :notifications, as: :noteable

  validates :user_id, uniqueness: {scope: :event_id}

  after_create :create_join_notification
  before_destroy :create_leave_notification

  def create_join_notification
    event = self.event
    participants = event.participants.where('user_id <> ?', self.user_id)
    if participants.any?
      participants.each do |p|
        self.notifications.create(user_id: p.id)
      end
    end
  end

  def create_leave_notification
    event = self.event
    participants = event.participants.where('user_id <> ?', self.user_id)
    if participants.any?
      participants.each do |p|
        self.notifications.create(user_id: p.id)
      end
    end
  end
end
