class Ethnicity < ActiveRecord::Base
  attr_accessible :name
  belongs_to :users

end
