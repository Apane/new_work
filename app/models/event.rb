class Event < ActiveRecord::Base
  attr_accessible :title, :description, :location, :date, :time, :event_date

  acts_as_commentable
  has_many :comments, as: :commentable
  belongs_to :user
  has_many :event_participants
  has_many :participants, through: :event_participants, source: :user

  after_create :update_event_date

  def update_event_date
    date = self.date.to_s
    time = self.time

    hour = Time.parse(time).strftime("%H:%M:%S").to_s
    event_date = (date + ' ' + hour).to_time
    self.update_attributes(event_date: event_date)
  end
end
