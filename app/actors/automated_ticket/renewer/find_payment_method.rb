# frozen_string_literal: true

class AutomatedTicket::Renewer::FindPaymentMethod < Actor
  input :automated_ticket
  output :payment_method_id
  def call
    self.payment_method_id =  automated_ticket.payment_method_client_internal_ids[0] unless automated_ticket.free
  end
end
