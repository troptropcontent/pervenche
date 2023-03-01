# frozen_string_literal: true

class AutomatedTicket::Renewer::FindPaymentMethod < Actor
  input :automated_ticket
  output :payment_method_id
  def call
    unless automated_ticket.payment_method_client_internal_id == 'free'
      self.payment_method_id = automated_ticket.payment_method_client_internal_id   
    end
  end
end
