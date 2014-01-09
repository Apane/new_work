class AddIsNewToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_new, :boolean, default: true
  end
end
