# frozen_string_literal: true

class AutomatedTicket::Renewer::RequestNewTicket < Actor
  input :automated_ticket
  input :payment_method_id
  input :time_unit
  input :quantity
  output :ticket_request

  def call
    request_new_ticket!
    save_ticket_request!
  end

  private

  def request_new_ticket!
    automated_ticket.renew!(
      quantity: quantity, 
      time_unit: time_unit, 
      payment_method_client_internal_id: payment_method_id
    )
  end

  def save_ticket_request!
    self.ticket_request = TicketRequest.create!({
      automated_ticket_id: automated_ticket.id,
      payment_method_client_internal_id: payment_method_id,
      requested_on: Time.current,
      quantity: quantity, 
      time_unit: time_unit}
    )
  end
end
