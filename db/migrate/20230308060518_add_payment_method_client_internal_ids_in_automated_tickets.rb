class AddPaymentMethodClientInternalIdsInAutomatedTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :automated_tickets, :payment_method_client_internal_ids, :string, array: true
  end
end
