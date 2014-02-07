class Event < ActiveRecord::Base
  attr_accessible :title, :description, :location, :date, :time, :event_date, :lat, :lng,
        :location_name, :event_type, :max_attendees, :postal_code, :country, :state, :district, :city, :image

  acts_as_commentable
  has_many :comments, as: :commentable
  belongs_to :user
  has_many :event_participants, dependent: :destroy
  has_many :participants, through: :event_participants, source: :user
  has_many :notifications, as: :noteable

  after_create :update_event_date, :add_owner_to_participants

  mount_uploader :image, EventImageUploader

  def update_event_date
    date = self.date.to_s
    time = self.time

    hour = Time.parse(time).strftime("%H:%M:%S").to_s
    event_date = (date + ' ' + hour).to_time
    self.update_attributes(event_date: event_date)
  end

  def owner_is?(user)
    self.user_id == user.id
  end

  def is_private?
    self.event_type
  end

  # add owner to partipants list
  def add_owner_to_participants
   EventParticipant.create(user_id: self.user_id, event_id: self.id)
  end
end
