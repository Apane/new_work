class AddIsWaitingToEventParticipants < ActiveRecord::Migration
  def change
    add_column :event_participants, :is_waiting, :integer, default: false
  end
end
