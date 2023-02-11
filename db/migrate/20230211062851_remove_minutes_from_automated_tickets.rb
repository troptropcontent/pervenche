class RemoveMinutesFromAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    remove_column :automated_tickets, :minutes, :integer
  end
end
