# frozen_string_literal: true

class AutomatedTicket::Renewer::FindTimeUnitAndQuantity < Actor
  input :automated_ticket
  input :jid, default: nil
  output :time_unit
  output :quantity
  def call
    instrumentation_data = { jid: }
    instrumentation_name = 'job.automated_tickets.renewer_job.find_time_unit_and_quantity_actor'
    ActiveSupport::Notifications.instrument instrumentation_name, instrumentation_data do
      self.time_unit = automated_ticket.accepted_time_units.include?('days') ? 'days' : 'hours'
      self.quantity = 1
    end
  end
end
