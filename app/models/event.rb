class Event < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search, against: [:title, :description],
    using: {tsearch: {prefix: true, dictionary: "english"}}

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  attr_accessible :title, :description, :location, :date, :time, :event_date, :lat, :lng, :location_name, :gender,
      :event_type, :max_attendees, :postal_code, :country, :state, :district, :city, :image, :category_id, :ethnicity_id,
      :ages

  attr_accessor :ages

  acts_as_commentable
  has_many :comments, as: :commentable
  belongs_to :user
  has_many :event_participants, dependent: :destroy
  has_many :participants, -> { where(event_participants: {is_waiting: false}) }, through: :event_participants, source: :user
  has_many :waiting_participants, -> { where(event_participants: {is_waiting: true}) }, through: :event_participants, source: :user
  has_many :notifications, as: :noteable
  has_many :categories

  before_save :set_min_max_age
  after_create :update_event_date, :add_owner_to_participants

  mount_uploader :image, EventImageUploader

  GENDER = {
    0 => "Female",
    1 => "Male"
  }

  def set_min_max_age
    if self.ages.present?
      ages = self.ages.split('-')
      self.age_min = ages[0]
      self.age_max = ages[1]
    end
  end

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

  def expired?
    self.event_date <= Time.now
  end

  # add owner to partipants list
  def add_owner_to_participants
   EventParticipant.create(user_id: self.user_id, event_id: self.id)
  end

  def create_join_notification(participant)
    participants = self.participants.where('user_id <> ?', participant.id)
    if participants.any?
      participants.each do |p|
        self.notifications.create(user_id: p.id)
      end
    end
  end

  def create_leave_notification(participant)
    participants = self.participants.where('user_id <> ?', participant.id)
    if participants.any?
      participants.each do |p|
        self.notifications.create(user_id: p.id)
      end
    end
  end

  def self.filtered(terms)
    events = Event.search(terms)
  end

  def self.scoped_by_search(user, distance, time, cat_ids, gender, ethnicity, age_min, age_max)
    if time.present?
      if time == '1'
        time = Date.today
      else
        time = DateTime.now.tomorrow.to_date
      end
    end

    events = self.all
    events = events.within(distance, :origin => user) unless distance.empty?
    events = events.where(date: time) if time.present?
    events = events.where(category_id: cat_ids) if cat_ids.present?
    events = events.where(gender: gender) unless gender.empty?
    events = events.where(ethnicity_id: ethnicity) unless ethnicity.empty?
    events_by_min = events.where(age_min: age_min..age_max)
    events_by_max = events.where(age_max: age_min..age_max)
    events = (events_by_min + events_by_max).uniq
    events
  end

  def self.clear_expired
    where('event_date <= ?', 1.week.ago).delete_all
  end
end
