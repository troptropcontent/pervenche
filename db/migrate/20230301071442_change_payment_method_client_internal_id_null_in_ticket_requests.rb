class ChangePaymentMethodClientInternalIdNullInTicketRequests < ActiveRecord::Migration[7.0]
  def change
    change_column_null :ticket_requests, :payment_method_client_internal_id, true
  end
end
