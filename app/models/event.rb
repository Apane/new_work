class Event < ActiveRecord::Base
  attr_accessible :title, :description, :location, :date

  belongs_to :user
end
