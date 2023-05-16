# frozen_string_literal: true

class AutomatedTicket::Setup::FindNextStep < Actor
  input :automated_ticket
  input :step
  output :next_step
  def call
    step_index = AutomatedTicket.setup_steps.keys.index(step)
    self.next_step = AutomatedTicket.setup_steps.keys[step_index + 1]
  end
end
