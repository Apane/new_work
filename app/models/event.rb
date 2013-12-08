class Event < ActiveRecord::Base
  attr_accessible :title, :description, :location, :date, :time

  belongs_to :user
end
