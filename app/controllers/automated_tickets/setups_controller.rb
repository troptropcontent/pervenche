class AutomatedTickets::SetupsController < ApplicationController
  before_action :load_automated_ticket
  before_action :load_step!
  before_action :authorize_access!

  # GET /automated_tickets/:automated_ticket_id/setups/:id
  def show
    render @step
  end

  def update; end

  private

  def load_automated_ticket
    @automated_ticket = AutomatedTicket.find(params[:automated_ticket_id])
  end

  def load_step!
    if AutomatedTicket.setup_steps[params[:id].to_sym]
      @step = params[:id]
    else
      not_found
    end
  end

  def authorize_access!
    authorize! :setup, @automated_ticket
  end

  def next_step; end
end
