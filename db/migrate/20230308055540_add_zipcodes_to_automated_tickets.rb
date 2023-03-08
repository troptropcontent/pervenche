class AddZipcodesToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :zipcodes, :string, array: true
  end
end
