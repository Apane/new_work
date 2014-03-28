class Authorization < ActiveRecord::Base
  attr_accessible :provider, :uid, :token, :secret, :first_name, :last_name, :link, :name, :connections_count

  def update_connections_number(provider)
    if provider == 'Facebook'
      connections_count = Koala::Facebook::API.new(self.token).get_connections("me", "friends").count
      self.update_attributes(connections_count: connections_count)
    elsif provider == 'LinkedIn'
      client = LinkedIn::Client.new(ENV['FR_LINKEDIN_KEY'], ENV['FR_LINKEDIN_SECRET'])
      client.authorize_from_access(self.token, self.secret)
      self.update_attributes(connections_count: client.connections.total)
    end
  end

end
