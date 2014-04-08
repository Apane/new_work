class Report < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :user
  belongs_to :reportable, polymorphic: true
end
