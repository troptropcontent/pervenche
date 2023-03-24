# frozen_string_literal: true

class AutomatedTicket::Renewer::FindOrSaveRunningTicket < Actor
  input :automated_ticket
  output :running_ticket
  def call
    return if self.running_ticket = automated_ticket.running_ticket_in_database

    running_ticket_in_client = automated_ticket.running_ticket_in_client
    self.running_ticket = if running_ticket_in_client
                            automated_ticket.tickets.create(running_ticket_in_client.except(:client))
                          end
  end
end
