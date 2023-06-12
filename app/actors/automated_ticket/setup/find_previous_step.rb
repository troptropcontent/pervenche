# frozen_string_literal: true

class AutomatedTicket::Setup::FindPreviousStep < Actor
  input :automated_ticket
  input :step
  output :previous_step
  def call
    step_index = AutomatedTicket.setup_steps.keys.index(step)
    previous_step = nil
    previous_step = AutomatedTicket.setup_steps.keys[step_index - 1] if step_index > 1
    self.previous_step = previous_step
  end
end
