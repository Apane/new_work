class Photo < ActiveRecord::Base
  attr_accessible :file, :profile_photo, :title, :crop_x, :crop_y, :crop_w, :crop_h, :description

  belongs_to :attachable, :polymorphic => true
  mount_uploader :file, FileUploader
  before_create :default_name

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  def default_name
    self.title ||= File.basename(file.filename, '.*').titleize if file
  end

  def crop_avatar
    self.file.recreate_versions! if crop_x.present?
  end

  def is_owned_by?(user)
    if self.attachable == user
      return true
    else
      return false
    end
  end
end
