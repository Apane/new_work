class User < ActiveRecord::Base
  include PgSearch

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:facebook, :twitter, :linkedin]

  attr_accessible :email, :password, :password_confirmation, :zip, :gender, :remember_me, :first_name, :last_name,
                  :birthday, :current_password, :occupation, :address, :interests, :aboutme, :profile_image,
                  :photos_attributes, :age, :education_id, :ethnicity_id, :blurb

  has_many :authorizations, :dependent => :destroy
  has_many :comments
  has_many :events
  has_many :photos, as: :attachable
  has_many :questions
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id
  belongs_to  :ethnicity
  belongs_to  :education

  accepts_nested_attributes_for :photos
  mount_uploader :profile_image, ProfileImageUploader

  validates :gender, :presence => true
  validates :zip, :presence => true
  validates_length_of :blurb, :minimum => 5, :maximum => 140, :allow_blank => true


  after_create :create_questions, :set_age
  before_save :set_age

  # pg_search_scope :search_by_full_name, :against => [:first_name, :last_name], :using => [:tsearch]

  pg_search_scope :search, against: [:first_name, :last_name],
    using: {tsearch: {prefix: true, dictionary: "english"}},
    associated_against: {questions: [:answer]}

  DEGREE = {
    '' => "None",
    '1' => "Bachelor",
    '2' => "Master",
    '3' => "Doctorate"
  }

  ETHNICITY = {
    '' => "Asian",
    '1' => "Indian",
    '2' => "Black",
    '3' => "White"
  }

  GENDER = {
    0 => "Female",
    1 => "Male",
  }
  def create_questions
    Question::QUESTIONS_FOR_ABOUT.map{|q| self.questions.create(question: q, for_about: true)}
    Question::QUESTIONS_FOR_PERSONALITY.map{|q| self.questions.create(question: q, for_personality: true)}
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

  # Not used anywhere
  # def format_date
  #   if self.birthday.present?
  #     today = Date.today
  #     d = Date.new(today.year, self.birthday.month, self.birthday.day)
  #     age = d.year - self.birthday.year - (d > today ? 1 : 0)
  #   else
  #     self.birthday.year : link_to('Add Birthday', edit_account_path)
  #   end
  # end

  def disconnect(social)
    if social == 'facebook'
      auth = self.authorizations.where(provider: 'Facebook').first
      auth.update_attributes(token: nil, secret: nil)
    elsif social == 'twitter'
      auth = self.authorizations.where(provider: 'Twitter').first
      auth.update_attributes(token: nil, secret: nil)
    elsif 'linkedin'
      auth = self.authorizations.where(provider: 'LinkedIn').first
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

  def self.scoped_by_search(terms, min_age, max_age, education_id, ethnicity_id, gender)
    min = min_age.present? ? min_age : 18
    max = max_age.present? ? max_age : 100
    #TODO find a way to limit the number of users loaded - replace User.all below.
    users = terms.present? ? User.search(terms) : User.all
    users = users.where('age >= ? and age <= ?', min, max)
    users = users.where('education_id = ?', education_id) if education_id.present?
    users = users.where('ethnicity_id = ?', ethnicity_id) if ethnicity_id.present?
    users = users.where('gender = ?', gender) if gender.present?
    users
  end
end
