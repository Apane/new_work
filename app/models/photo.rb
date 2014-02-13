class Photo < ActiveRecord::Base
  attr_accessible :file

  belongs_to :attachable, :polymorphic => true

  mount_uploader :file, FileUploader

before_create :default_name

def default_name
  self.title ||= File.basename(file.filename, '.*').titleize if file
end

end
