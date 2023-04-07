# frozen_string_literal: true

class AutomatedTicketsController < ApplicationController
  load_and_authorize_resource

  # GET /automated_tickets/new
  def new
    automated_ticket = new_automated_ticket
    next_step = next_step_for(automated_ticket)
    path = path_for(automated_ticket, next_step)
    redirect_to path
  end

  # GET   /automated_tickets/:id
  def show
    @last_tickets = @automated_ticket.tickets.order(starts_on: :desc).limit(10)
  end

  # DELETE /automated_tickets/:id
  def destroy
    if @automated_ticket.destroy
      redirect_to root_path
    else
      @last_tickets = @automated_ticket.tickets.order(starts_on: :desc).limit(10)
      render :show
    end
  end

  # GET   /automated_tickets
  def index
    @automated_tickets = @automated_tickets.includes(:running_tickets_in_database)
  end

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

  def new_automated_ticket
    automated_ticket = current_user.automated_tickets.new
    automated_ticket.save(validate: false)
    AutomatedTicket::Setup::CompleteAlreadyCompletableSteps.call(
      automated_ticket:
    ).automated_ticket
  end

  def next_step_for(automated_ticket)
    AutomatedTicket::Setup::FindNextStep.call(automated_ticket:).next_step
  end

  def path_for(automated_ticket, step)
    AutomatedTicket::Setup::FindPath.call(automated_ticket:, step:).path
  end
end
