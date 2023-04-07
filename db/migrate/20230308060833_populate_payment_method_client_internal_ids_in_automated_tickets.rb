class PopulatePaymentMethodClientInternalIdsInAutomatedTickets < ActiveRecord::Migration[7.0]
  def up
    AutomatedTicket.find_each do |automated_ticket|
      automated_ticket.update(payment_method_client_internal_ids: [automated_ticket.payment_method_client_internal_id])
    end
  end

  def down
    AutomatedTicket.find_each do |automated_ticket|
      automated_ticket.update(payment_method_client_internal_id: automated_ticket.payment_method_client_internal_ids[0])
    end
  end
end
