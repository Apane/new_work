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
      :ages, :remove_image

  attr_accessor :ages

  acts_as_commentable
  has_many :comments, as: :commentable
  belongs_to :user
  has_many :event_participants, dependent: :destroy
  has_many :participants, -> { where(event_participants: {is_waiting: false}) }, through: :event_participants, source: :user
  has_many :waiting_participants, -> { where(event_participants: {is_waiting: true}) }, through: :event_participants, source: :user
  has_many :notifications, as: :noteable
  has_many :categories
  has_many :reports, as: :reportable

  before_save :update_event_date, :set_min_max_age
  after_create :add_owner_to_participants

  mount_uploader :image, EventImageUploader

  GENDER = {
    0 => "Female",
    1 => "Male"
  }

  def set_min_max_age
    Common.set_min_max_age(self)
  end

  def update_event_date
    Common.update_event_date(self)
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

  def create_notification(participant, key)
    participants = self.participants.where('user_id <> ?', participant.id)
    if participants.any?
      participants.each do |p|
        Notification.send_notification(p, participant, self, "#{participant.username} #{key} #{self.title} event!")
      end
    end
  end

  def self.filtered(terms)
    events = Event.search(terms)
  end

  def self.scoped_by_search(user, search)
    distance = search[:distance]
    time = search[:time]
    cat_ids = search[:cat_ids].split('').uniq
    gender = search[:gen]
    ethnicity = search[:ethn]
    age_min = search[:age_min]
    age_max = search[:age_max]
    if time.present?
      (time == '1') ? (time = Date.today) : (time = DateTime.now.tomorrow.to_date)
    end

    #TODO find a way to replace .all
    events = all
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

  def max_event_attendees
    return max_attendees.present? ? (self.max_attendees) : 100
  end

  def attend(user)
    if self.is_private?
      notice = "private"
    elsif !(age_min..age_max).include?(user.age)
      notice = "restricted by age, only those whos age are between #{age_min} and #{age_max} are allowed."
    elsif self.gender.present? && self.gender != user.gender
      notice = "restricted by gender, only #{Event::GENDER[self.gender].downcase} are allowed."
    else
      max_attendees = self.max_event_attendees
      participants = self.participants
      if participants.size >= max_attendees
        event_participant = self.event_participants.create(event_id: self.id, user_id: user.id, is_waiting: true)
      else
        event_participant = self.event_participants.create(event_id: self.id, user_id: user.id)
      end
      waiting_participants = self.waiting_participants
      self.create_notification(user, 'joined')
    end

    return [event_participant, participants, waiting_participants, notice]
  end

  def stop_attend(user)
    attendees_count = self.participants.size
    max_attendees = self.max_attendees.present? ? (self.max_attendees) : 100
    participant = self.event_participants.where(user_id: user.id, event_id: self.id).first
    participant.remove_and_update_queue(self, max_attendees)
    self.create_notification(user, 'left')
    return participant
  end
end
