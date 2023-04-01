# frozen_string_literal: true

class AutomatedTicket::Renewer::RequestNewTicket < Actor
  input :automated_ticket
  input :zipcode
  input :time_unit
  input :quantity
  input :payment_method_id, allow_nil: true
  output :ticket_request

  def call
    request_new_ticket!
    save_ticket_request!
  end

  private

  def request_new_ticket!
    automated_ticket.renew!(
      zipcode:,
      quantity:,
      time_unit:,
      payment_method_client_internal_id: payment_method_id
    )
  end

  def save_ticket_request!
    self.ticket_request = TicketRequest.create!({
                                                  automated_ticket_id: automated_ticket.id,
                                                  zipcode:,
                                                  payment_method_client_internal_id: payment_method_id,
                                                  requested_on: Time.current,
                                                  quantity:,
                                                  time_unit:
                                                })
  end
end
