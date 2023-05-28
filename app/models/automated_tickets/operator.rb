# frozen_string_literal: true
# typed: strict

class AutomatedTickets::Operator
  extend T::Sig

  sig { params(automated_ticket: AutomatedTicket).void }
  def initialize(automated_ticket)
    @automated_ticket = automated_ticket
  end

  sig { returns(T.nilable(AutomatedTickets::SetupStep)) }
  def next_completable_step
    AutomatedTicket.setup_steps.keys.each do |step_name|
      @automated_ticket.setup_step = step_name
      return AutomatedTickets::SetupStep.new(step_name) if @automated_ticket.invalid?
    end
    nil
  end
end
