Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FR_FACEBOOK_KEY'], ENV['FR_FACEBOOK_SECRET'], :scope => "email,user_birthday", image_size: 'large'
  #provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], :scope => 'r_fullprofile r_emailaddress r_network'
end
