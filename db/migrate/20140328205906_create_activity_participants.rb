class CreateActivityParticipants < ActiveRecord::Migration
  def change
    create_table :activity_participants do |t|
      t.belongs_to :user, index: true
      t.belongs_to :activity, index: true

      t.timestamps
    end
  end
end
