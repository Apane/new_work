class AddDeletedFieldsToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :deleted_for_sender, :boolean, default: false
    add_column :messages, :deleted_for_receiver, :boolean, default: false
  end
end
