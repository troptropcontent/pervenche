class AddAcceptedTimeUnitsToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :accepted_time_units, :string, array: true
  end
end
