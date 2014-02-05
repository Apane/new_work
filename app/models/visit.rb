class Visit < ActiveRecord::Base
  belongs_to :user
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id'

  attr_accessible :visited_at, :visitor_id

  after_create :update_time

  def update_time
    self.update_attributes(visited_at: Time.now)
  end
end
