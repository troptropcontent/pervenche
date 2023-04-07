class AddFreeColumnToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :free, :boolean, default: false
  end
end
