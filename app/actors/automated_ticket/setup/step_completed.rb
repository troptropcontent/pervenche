# frozen_string_literal: true

class AutomatedTicket::Setup::StepCompleted < Actor
  input :automated_ticket
  input :step
  output :step_completed
  def call
    automated_ticket.setup_step = step
    self.step_completed = automated_ticket.valid?.tap do
      automated_ticket.errors.clear
    end
  end
end
