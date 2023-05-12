class AddKindToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :kind, :integer, null: false, defalt: 0 
  end
end
