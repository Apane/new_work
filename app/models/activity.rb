class Activity < ActiveRecord::Base
  include PgSearch

  pg_search_scope :search, against: [:title, :description],
    using: {tsearch: {prefix: true, dictionary: "english"}}

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  attr_accessible :title, :description, :location, :date, :time, :activity_date,
        :lat, :lng, :location_name, :activity_type, :postal_code, :country,
        :state, :city, :frequency_id, :category_id, :gender, :ethnicity_id,
        :age_min, :age_max, :ages, :district, :image, :remove_image

  validates :title, :description, :date, :location, :date, :time, :location_name,
            :city, :state, :postal_code, presence: true

  attr_accessor :ages

  acts_as_commentable
  has_many :comments, as: :commentable
  has_many :activity_participants, dependent: :destroy
  has_many :participants, through: :activity_participants, source: :user
  has_many :reports, as: :reportable

  belongs_to :user
  before_save :set_min_max_age
  after_create :update_event_date, :add_owner_to_participants

  mount_uploader :image, ActivityImageUploader

  FREQUENCY = {
    0 => "Other",
    1 => "Daily",
    2 => "Once a week",
    3 => "Once a month"
  }

  def add_owner_to_participants
    ActivityParticipant.create(user_id: self.user_id, activity_id: self.id)
  end

  def set_min_max_age
    ages = self.ages.split('-')
    self.age_min = ages[0]
    self.age_max = ages[1]
  end

  def update_event_date
    date = self.date.to_s
    time = self.time

    hour = Time.parse(time).strftime("%H:%M:%S").to_s
    event_date = (date + ' ' + hour).to_time
    self.update_attributes(activity_date: event_date)
  end

  def owner_is?(user)
    self.user_id == user.id
  end

  def is_private?
    self.activity_type
  end

  def create_join_notification(participant)
    participants = self.participants.where('user_id <> ?', participant.id)
    if participants.any?
      participants.each do |p|
        Notification.send_notification(p, participant, self, "#{participant.username} is interested in #{self.title.html_safe} activity")
      end
    end
  end

  def frequency
    Activity::FREQUENCY[self.frequency_id]
  end

  def self.filtered(terms)
    activities = Activity.search(terms)
    activities
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
      if time == '1'
        time = Date.today
      else
        time = DateTime.now.tomorrow.to_date
      end
    end

    #acts = activities
    acts = self.all
    acts = acts.within(distance, :origin => user) unless distance.empty?
    acts = acts.where(date: time) if time.present?
    acts = acts.where(category_id: cat_ids) if cat_ids.present?
    acts = acts.where(gender: gender) unless gender.empty?
    acts = acts.where(ethnicity_id: ethnicity) unless ethnicity.empty?
    acts_by_min = acts.where(age_min: age_min..age_max)
    acts_by_max = acts.where(age_max: age_min..age_max)
    acts = (acts_by_min + acts_by_max).uniq
    acts
  end

  def attend(user)
    if self.is_private?
      notice = "private"
    elsif !(age_min..age_max).include?(user.age)
      notice = "restricted by age, only those whos age are between #{age_min} and #{age_max} are allowed."
    elsif self.gender.present? && self.gender != user.gender
      notice = "restricted by gender, only #{Event::GENDER[self.gender].downcase} are allowed."
    else
      self.activity_participants.create(activity_id: self.id, user_id: user.id)
      self.create_join_notification(user)
    end
    return [notice]
  end
end
