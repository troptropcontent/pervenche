class AddWeekdaysToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :weekdays, :integer, array: true
  end
end
