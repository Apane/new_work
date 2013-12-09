class Authorization < ActiveRecord::Base
  attr_accessible :provider, :uid, :token, :secret, :first_name, :last_name, :link, :name
end
