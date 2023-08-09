# frozen_string_literal: true

class AutomatedTicket::Renewer::FindPaymentMethod < Actor
  input :automated_ticket
  output :payment_method_id
  input :jid, default: nil
  def call
    instrumentation_data = { jid: }
    instrumentation_name = 'job.automated_tickets.renewer_job.find_payment_method_actor'
    ActiveSupport::Notifications.instrument instrumentation_name, instrumentation_data do
      self.payment_method_id = (automated_ticket.payment_method_client_internal_ids[0] unless automated_ticket.free)
    end
  end
end
