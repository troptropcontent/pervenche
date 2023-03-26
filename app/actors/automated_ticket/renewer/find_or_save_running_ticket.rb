# frozen_string_literal: true

class AutomatedTicket::Renewer::FindOrSaveRunningTicket < Actor
  input :automated_ticket
  input :zipcode
  output :running_ticket
  def call
    return if (self.running_ticket = automated_ticket.running_ticket_in_database_for(zipcode:))

    running_ticket_in_client = automated_ticket.running_ticket_in_client_for(zipcode:)

    self.running_ticket = if running_ticket_in_client
                            automated_ticket.tickets.create(
                              running_ticket_in_client.except(:client).merge({ zipcode: })
                            )
                          end
  end
end
