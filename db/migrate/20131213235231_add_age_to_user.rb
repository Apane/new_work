class AddAgeToUser < ActiveRecord::Migration
  def change
    add_column :users, :age, :integer

    User.all.each do |user|
      if user.birthday.present?
        today = Date.today
        d = Date.new(today.year, user.birthday.month, user.birthday.day)
        age = d.year - user.birthday.year - (d > today ? 1 : 0)
        user.update_attributes(age: age)
      end
    end
  end
end
