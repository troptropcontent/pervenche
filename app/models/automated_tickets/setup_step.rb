# frozen_string_literal: true
# typed: strict

class AutomatedTickets::SetupStep
  extend T::Sig
  sig { params(automated_ticket: AutomatedTicket, step: Symbol).void }
  def initialize(automated_ticket, step)
    @automated_ticket = automated_ticket
    @step = step
  end

  sig { params(another_step_name: Symbol).returns(T::Boolean) }
  def before?(another_step_name)
    step_index = AutomatedTicket.setup_steps.keys.index(@step)
    another_step_index = AutomatedTicket.setup_steps.keys.index(another_step_name)
    step_index < another_step_index
  end

  sig { returns(Symbol) }
  def name
    @step
  end
end
