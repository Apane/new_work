class AddOpenedFieldsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :opened, :boolean, default: false
    add_column :messages, :opened_at, :datetime
  end
end
