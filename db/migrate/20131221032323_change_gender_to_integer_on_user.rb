class ChangeGenderToIntegerOnUser < ActiveRecord::Migration
  def change
    User.where(gender: 'M').update_all(gender: 1)
    User.where(gender: 'F').update_all(gender: 0)
    change_column :users, :gender, 'integer USING CAST(gender AS integer)'
  end
end
