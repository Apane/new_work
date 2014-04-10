class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  require 'uuidtools'

  def facebook
    oauthorize "Facebook"
  end

  def twitter
    oauthorize "Twitter"
  end

  def linkedin
    oauthorize "LinkedIn"
  end

  def gplus
    oauthorize "GPlus"
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

private

  def oauthorize(kind)
    @user = find_for_ouath(kind, env["omniauth.auth"], current_user)

    if @user
      kind = 'Google+' if kind == 'GPlus'
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
      session["devise.#{kind.downcase}_data"] = env["omniauth.auth"]
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def find_for_ouath(provider, access_token, resource=nil)
    user, email, name, uid, auth_attr = nil, nil, nil, {}
    case provider
      when "Facebook"
        uid = access_token['uid']
        email = access_token['info']['email']
        auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
          :secret => nil, :first_name => access_token['info']['first_name'],
          :last_name => access_token['info']['last_name'], :name => access_token['info']['name'],
          :link => access_token['extra']['raw_info']['link'] }
      when "Twitter"
        uid = access_token['extra']['raw_info']['id']
        name = access_token['extra']['raw_info']['name']
        auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
          :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
          :last_name => access_token['info']['last_name'], :name => name,
          :link => "http://twitter.com/#{name}", :connections_count => access_token['extra']['raw_info']['followers_count'] }
      when 'LinkedIn'
        uid = access_token['uid']
        name = access_token['info']['name']
        auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
          :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
          :last_name => access_token['info']['last_name'],
          :link => access_token['info']['public_profile_url'] }
      when 'GPlus'
        uid = access_token['uid']
        name = access_token['info']['email']
        auth_attr = { :uid => uid, :token => access_token['credentials']['token'],
          :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
          :last_name => access_token['info']['last_name'],
          :link => access_token['info']['image'] }
    else
      raise 'Provider #{provider} not handled'
    end
    if resource.nil?
      if email
        user = find_for_oauth_by_email(email, resource)
      elsif uid && name
        user = find_for_oauth_by_uid(uid, resource)
        if user.nil?
          user = find_for_oauth_by_name(name, resource)
        end
      end
    else
      user = resource
    end

    auth = user.authorizations.find_by_provider(provider)
    if auth.nil?
      auth = user.authorizations.build(:provider => provider)
      user.authorizations << auth
    end
    auth.update_attributes auth_attr
    auth.update_connections_number(provider)
    return user
  end

  def find_for_oauth_by_uid(uid, resource=nil)
    user = nil
    if auth = Authorization.find_by_uid(uid.to_s)
      user = auth.user
    end
    return user
  end

  def find_for_oauth_by_email(email, resource=nil)
    if user = User.find_by_email(email)
      user
    else
      user = User.new(:email => email, :password => Devise.friendly_token[0,20])
      user.save
    end
    return user
  end

  def find_for_oauth_by_name(name, resource=nil)
    if user = User.find_by_name(name)
      user
    else
      first_name = name
      last_name = name
      user = User.new(:first_name => first_name, :last_name => last_name, :password => Devise.friendly_token[0,20], :email => "#{UUIDTools::UUID.random_create}@host")
      user.save(:validate => false)
    end
    return user
  end

end
