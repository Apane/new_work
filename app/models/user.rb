class User < ActiveRecord::Base
  include PgSearch
  paginates_per 10

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:facebook, :twitter, :linkedin, :gplus]

  attr_accessible :email, :password, :password_confirmation, :zip, :remember_me, :first_name, :last_name,
                  :birthday, :current_password, :occupation, :address, :interests, :aboutme, :profile_image,
                  :photos_attributes, :age, :education_id, :ethnicity_id, :blurb, :gender, :email_confirmation,
                  :lat, :lng

  attr_accessor :email_confirmation

  has_many :authorizations, :dependent => :destroy
  has_many :comments
  has_many :events
  has_many :activities
  has_many :photos, as: :attachable
  has_many :questions
  has_many :conversations, foreign_key: 'author_id'
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :inbox_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :new_messages, -> { where is_new: true }, class_name: 'Message', foreign_key: 'recipient_id'
  belongs_to  :ethnicity
  belongs_to  :education
  has_many :event_participants, dependent: :destroy
  has_many :attended_events, through: :event_participants, source: :event
  has_many :notifications
  has_many :new_notifications, -> { where is_opened: false }, class_name: 'Notification'
  has_many :visits, dependent: :destroy
  has_many :visitors, through: :visits
  has_many :recent_visitors, through: :visits, source: :visitor, conditions: [ "visits.visited_at > ?", 1.month.ago ]
  has_many :favorites
  has_many :people_who_favorited_me, class_name: 'Favorite', foreign_key: 'favorite_id'
  has_many :hidden_users, dependent: :destroy
  has_many :blocked_users, dependent: :destroy
  has_one :mail_setting, dependent: :destroy

  scope :active, -> { where(disabled_at: nil) }

  accepts_nested_attributes_for :photos
  mount_uploader :profile_image, ProfileImageUploader

  # validates :gender, :presence => true
  # validates :zip, :presence => true
  validates_length_of :blurb, :minimum => 5, :maximum => 140, :allow_blank => true


  after_create :create_questions_and_mail_settings, :set_age
  before_save :set_age, :get_gps_data

  # pg_search_scope :search_by_full_name, :against => [:first_name, :last_name], :using => [:tsearch]

  pg_search_scope :search, against: [:first_name, :last_name],
    using: {tsearch: {prefix: true, dictionary: "english"}},
    associated_against: {questions: [:answer]}

  DEGREE = {
    0 => "None",
    1 => "Bachelor",
    2 => "Master",
    3 => "Doctorate"
  }

  ETHNICITY = {
    0 => "Asian",
    1 => "Indian",
    2 => "Black",
    3 => "White"
  }

  GENDER = {
    0 => "Female",
    1 => "Male",
  }

  def profile_photo
    self.photos.where(profile_photo: true).first
  end

  def gender_hum
    User::GENDER[self.gender]
  end

  def gender_initial
    User::GENDER[self.gender][0]
  end

  def favorited?(user)
    fav_ids = self.favorites.pluck(:favorite_id)
    if fav_ids.include? user.id
      true
    end
  end

  def hidden_for?(user)
    user_ids = user.hidden_users.pluck(:hidden_user_id)
    if user_ids.include? self.id
      true
    end
  end

   def blocked_for?(user)
    user_ids = user.blocked_users.pluck(:blocked_user_id)
    if user_ids.include? self.id
      true
    end
  end

  def block(user)
    unless user.blocked_for?(self)
      self.blocked_users.find_or_create_by(blocked_user_id: user.id)
    end
  end

  def create_questions_and_mail_settings
    Question::QUESTIONS_FOR_ABOUT.map{|q| self.questions.create(question: q, for_about: true)}
    Question::QUESTIONS_FOR_PERSONALITY.map{|q| self.questions.create(question: q, for_personality: true)}
    MailSetting.create(user_id: self.id)
  end

  def number_of_users
    User.all.count
  end

  def name
    self.first_name.to_s + ' ' + self.last_name.to_s
  end

  def short_name
    self.first_name + ' ' + self.last_name[0,1] + '.'
  end

  def about_user
    self.questions.order('created_at asc').first.answer
  end

  def set_age
    if self.birthday.present?
      today = Date.today
      d = Date.new(today.year, self.birthday.month, self.birthday.day)
      age = d.year - self.birthday.year - (d > today ? 1 : 0)
      self.age = age
    end
  end

  def get_gps_data
    gps = Geokit::Geocoders::GoogleGeocoder.geocode self.address if self.address.present?
    if gps.present?
      self.zip = gps.zip
      self.lat = gps.lat
      self.lng = gps.lng
      self.city = gps.city
    end
  end

  def disconnect(social)
    if social == 'facebook'
      auth = self.authorizations.where(provider: 'Facebook').first
      auth.update_attributes(token: nil, secret: nil)
    elsif social == 'twitter'
      auth = self.authorizations.where(provider: 'Twitter').first
      auth.update_attributes(token: nil, secret: nil)
    elsif social == 'linkedin'
      auth = self.authorizations.where(provider: 'LinkedIn').first
      auth.update_attributes(token: nil, secret: nil)
    elsif social == 'googleplus'
      auth = self.authorizations.where(provider: 'GooglePlus').first
      auth.update_attributes(token: nil, secret: nil)
    end
  end

  def has_connection_with(provider)
    auth = self.authorizations.where(provider: provider).first
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def has_fb_connection?
    auth = self.authorizations.where(provider: 'Facebook').first
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def has_tw_connection?
    auth = self.authorizations.where(provider: 'Twitter').first
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def has_li_connection?
    auth = self.authorizations.where(provider: 'LinkedIn').first
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def has_gp_connection?
    auth = self.authorizations.where(provider: 'GPlus').first
    if auth.present?
      auth.token.present?
    else
      false
    end
  end

  def answered_to_about_questions?
    arr = self.questions.where(for_about: true).each do |q|
      if q.answer.nil?
        true.to_s
      else
        q.answer.empty? ? true.to_s : false.to_s
      end
    end

    if arr.include? 'true'
      return true
    else
      return false
    end
  end

  def answered_to_top_5_questions?
    arr = self.questions.where(for_about: nil).each do |q|
      if q.answer.nil?
        true.to_s
      else
        q.answer.empty? ? true.to_s : false.to_s
      end
    end

    if arr.include? 'true'
      return true
    else
      return false
    end
  end

  def answered_questions
    qs = []
    self.questions.each do |q|
      if !q.answer.nil?
        qs << q if !q.answer.empty?
      end
    end

    return qs
  end

  def profile_completed
    rate = 0
    (rate = rate + 10) if self.profile_photo.present?
    (rate = rate + 10) if self.age.present?
    if self.address != nil
      (rate = rate + 10) unless self.address.empty?
    end
    if self.occupation.present?
      (rate = rate + 5) unless self.occupation.empty?
    end
    (rate = rate + 10) if self.ethnicity.present?
    (rate = rate + 10) if self.education.present?
    # (rate = rate + 10) if self.answered_to_about_questions?
    # (rate = rate + 10) if self.answered_to_top_5_questions?
    (rate = rate + (5 * self.answered_questions.size))
    rate
  end

  def has_completed_profile?
    (self.profile_completed == 100) ? true : false
  end

  def self.filtered(terms)
    users = User.search(terms)
    users
  end

  def self.scoped_by_search(terms, min_age, max_age, education_id, ethnicity_ids, gender)
    min = min_age.present? ? min_age : 18
    max = max_age.present? ? max_age : 100
    #TODO find a way to limit the number of users loaded - replace User.all below.
    users = terms.present? ? User.search(terms) : User.all
    users = users.where('age >= ? and age <= ?', min, max)
    users = users.where('education_id = ?', education_id) if education_id.present?
    users = users.where(ethnicity_id: ethnicity_ids) if ethnicity_ids.present?
    users = users.where('gender = ?', gender) if gender.present?
    users
  end

  def disabled?
    self.disabled_at.present? ? true : false
  end

  def disable_account
    update_attribute(:disabled_at, Time.now)
  end

  def activate_account
    update_attribute(:disabled_at, nil)
  end

  def accepts_email_for_new_message?
    self.mail_setting.new_message?
  end

  def accepts_email_for_new_participant?
    self.mail_setting.join_event?
  end

  def accepts_email_for_new_comment?
    self.mail_setting.comment_on_event?
  end

  def accepts_email_for_new_visitor?
    self.mail_setting.viewed_profile?
  end
end
