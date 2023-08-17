class AddLastTimeActivatedAtOnAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :last_activated_at, :datetime
  end
end
