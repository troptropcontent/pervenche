class AutomatedTicketsController < ApplicationController
  def new
    automated_ticket = current_user.automated_tickets.new
    automated_ticket.service = current_user.services.first if current_user.services.count == 1
    automated_ticket.save(validate: false)
    redirect_to automated_ticket_setup_path(automated_ticket.id, AutomatedTicket.setup_steps.keys.first)
  end
end
