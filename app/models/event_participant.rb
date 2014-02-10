class EventParticipant < ActiveRecord::Base
  attr_accessible :user_id, :event_id

  belongs_to :user
  belongs_to :event
  has_many :notifications, as: :noteable

  validates :user_id, uniqueness: {scope: :event_id}
end
