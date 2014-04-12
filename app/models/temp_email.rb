class TempEmail < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :zip

  def self.create_temp_user(user)
    TempEmail.create(email: user[:email], first_name: user[:first_name],
        last_name: user[:last_name], zip: user[:zip])
  end
end
