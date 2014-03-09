class Photo < ActiveRecord::Base
  attr_accessible :file, :profile_photo, :title

  belongs_to :attachable, :polymorphic => true
  mount_uploader :file, FileUploader
  before_create :default_name

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  def default_name
    self.title ||= File.basename(file.filename, '.*').titleize if file
  end

  def crop_avatar
    file.recreate_versions! if crop_x.present?
  end

end
