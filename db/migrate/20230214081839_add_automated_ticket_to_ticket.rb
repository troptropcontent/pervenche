class AddAutomatedTicketToTicket < ActiveRecord::Migration[7.0]
  def change
    add_reference :tickets, :automated_ticket, null: false, foreign_key: true
  end
end
