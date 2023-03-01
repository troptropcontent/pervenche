# frozen_string_literal: true

class AutomatedTicket::Renewer::FindOrSaveRunningTicket < Actor
  input :automated_ticket
  output :running_ticket
  def call
    return if self.running_ticket = self.automated_ticket.running_ticket_in_database 
    running_ticket_in_client = self.automated_ticket.running_ticket_in_client
    if running_ticket_in_client
      self.running_ticket = self.automated_ticket.tickets.create(running_ticket_in_client.except(:client))
    else
      self.running_ticket = nil
    end
  end
end
