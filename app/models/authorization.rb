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

  def self.auth_social(provider, access_token)
    if provider == "Facebook"
      auth_facebook(access_token)
    elsif provider == "Twitter"
      auth_twitter(access_token)
    elsif provider == 'LinkedIn' || provider == 'GPlus'
      auth_linkedin_or_gplus(access_token, provider)
    else
      raise 'Provider #{provider} not handled'
    end
  end

  def self.auth_facebook(access_token)
    uid = access_token['uid']
    email = access_token['info']['email']
    auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
      :secret => nil, :first_name => access_token['info']['first_name'],
      :last_name => access_token['info']['last_name'], :name => access_token['info']['name'],
      :link => access_token['extra']['raw_info']['link'] }
    return [uid, name, auth_attr]
  end

  def self.auth_twitter(access_token)
    uid = access_token['extra']['raw_info']['id']
    name = access_token['extra']['raw_info']['name']
    auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
      :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
      :last_name => access_token['info']['last_name'], :name => name,
      :link => "http://twitter.com/#{name}", :connections_count => access_token['extra']['raw_info']['followers_count'] }
    return [uid, name, auth_attr]
  end

  def self.auth_linkedin_or_gplus(access_token, provider)
    uid = access_token['uid']
    name = access_token['info']['name']
    auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
      :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
      :last_name => access_token['info']['last_name'],
      :link => (provider == 'LinkedIn') ? access_token['info']['public_profile_url'] : access_token['info']['image'] }
    return [uid, name, auth_attr]
  end
end
