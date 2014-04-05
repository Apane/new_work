class CreateTempEmails < ActiveRecord::Migration
  def change
    create_table :temp_emails do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :zip

      t.timestamps
    end
  end
end
