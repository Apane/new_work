class Activity < ActiveRecord::Base
  include PgSearch

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  attr_accessible :title, :description, :location, :date, :time, :activity_date,
        :lat, :lng, :location, :location_name, :activity_type, :postal_code, :country,
        :state, :city, :frequency_id, :category_id, :gender, :ethnicity_id,
        :age_min, :age_max, :ages, :district

  validates :title, :description, :date, presence: true

  attr_accessor :ages

  belongs_to :user
  before_save :set_min_max_age
  after_create :update_event_date #, :add_owner_to_participants

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
    self.event_type
  end
end
