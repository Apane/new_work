class MailSetting < ActiveRecord::Base
  attr_accessible :user_id, :new_message, :new_reply, :join_event, :comment_on_event, :viewed_profile, :newsletter
  belongs_to :user
end
