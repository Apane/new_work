class AddConnectionsCountToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :connections_count, :integer
  end
end
