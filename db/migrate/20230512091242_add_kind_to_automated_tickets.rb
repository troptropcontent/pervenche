class AddKindToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :kind, :integer
  end
end
