# frozen_string_literal: true

class AutomatedTicket::Renewer::FindOrSaveRunningTicket < Actor
  input :automated_ticket
  input :zipcode
  input :jid, default: nil
  output :running_ticket
  def call
    instrumentation_data = { jid: }
    instrumentation_name = 'job.automated_tickets.renewer_job.find_or_save_running_ticket_actor'
    ActiveSupport::Notifications.instrument instrumentation_name, instrumentation_data do
      return if (self.running_ticket = automated_ticket.running_ticket_in_database_for(zipcode:))

      running_ticket_in_client = automated_ticket.running_ticket_in_client_for(zipcode:)

      self.running_ticket = if running_ticket_in_client
                              automated_ticket.tickets.create(
                                running_ticket_in_client.serialize.except('client').merge({ zipcode: })
                              )
                            end
    end
  end
end
