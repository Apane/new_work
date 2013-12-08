class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :zip,
                  :gender,
                  :remember_me,
                  :first_name,
                  :last_name,
                  :birthday,
                  :current_password,
                  :occupation,
                  :address,
                  :interests,
                  :aboutme,
                  :profile_image,
                  :photos_attributes

  has_many :events
  has_many :photos, as: :attachable
  has_many :questions
  accepts_nested_attributes_for :photos
  mount_uploader :profile_image, ProfileImageUploader

  validates :gender, :presence => true

  after_create :create_questions

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.gender = auth.extra.raw_info.gender
      user.email = auth.info.email
      user.address = auth.info.location
      user.fb_avatar_url = auth.info.image
      pass = Random.rand(1_000_000_000) # give a random password to pass validation
      user.password = pass
      user.password_confirmation = pass
      user.save!
    end
  end

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

  def format_date
    if self.birthday.present?
      today = Date.today
      d = Date.new(today.year, self.birthday.month, self.birthday.day)
      age = d.year - self.birthday.year - (d > today ? 1 : 0)
    else
      self.birthday.present? ? self.birthday.year : link_to('Add Birthday', edit_account_path)
    end
  end

  def has_fb_connection?
    self.uid.present?
  end
end
