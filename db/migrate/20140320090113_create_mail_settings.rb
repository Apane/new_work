class CreateMailSettings < ActiveRecord::Migration
  def change
    create_table :mail_settings do |t|
      t.integer :user_id
      t.boolean :new_message, default: :true
      t.boolean :new_reply, default: :true
      t.boolean :join_event, default: :true
      t.boolean :comment_on_event, default: :true
      t.boolean :viewed_profile, default: :true
      t.boolean :newsletter, default: :true

      t.timestamps
    end

    User.all.each do |user|
      MailSetting.create(user_id: user.id)
    end
  end
end
