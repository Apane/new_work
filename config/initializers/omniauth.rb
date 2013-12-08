Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FR_FACEBOOK_KEY'], ENV['FR_FACEBOOK_SECRET'], image_size: 'large'
end
