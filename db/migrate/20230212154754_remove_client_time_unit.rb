class RemoveClientTimeUnit < ActiveRecord::Migration[7.0]
  def change
    remove_column :automated_tickets, :client_time_unit, :integer
  end
end
