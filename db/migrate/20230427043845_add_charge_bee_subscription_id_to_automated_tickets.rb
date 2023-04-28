class AddChargeBeeSubscriptionIdToAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :charge_bee_subscription_id, :string
  end
end
