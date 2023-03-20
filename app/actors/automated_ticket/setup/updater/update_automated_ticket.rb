# frozen_string_literal: true

class AutomatedTicket::Setup::Updater::UpdateAutomatedTicket < Actor
  input :step
  input :params
  input :automated_ticket
  output :automated_ticket
  def call
    automated_ticket.setup_step = step
    automated_ticket.update(params)
  end
end
