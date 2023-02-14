class AutomatedTicketsController < ApplicationController
  load_and_authorize_resource
  def new
    automated_ticket = current_user.automated_tickets.new
    automated_ticket.service = current_user.services.first if current_user.services.count == 1
    automated_ticket.save(validate: false)
    redirect_to automated_ticket_setup_path(automated_ticket.id, AutomatedTicket.setup_steps.keys.first)
  end

  # GET   /automated_tickets
  def index; end

  def update
    if @automated_ticket.update(automated_ticket_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private

  def automated_ticket_params
    params.require(:automated_ticket).permit(:active)
  end
end
