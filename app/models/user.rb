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

  has_many :photos, as: :attachable
  accepts_nested_attributes_for :photos
  mount_uploader :profile_image, ProfileImageUploader

  validates :gender, :presence => true 

  def number_of_users
    User.all.count
  end

end
