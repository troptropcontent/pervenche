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
    AutomatedTicket.setup_steps.each_key do |step_name|
      @automated_ticket.setup_step = step_name
      return AutomatedTickets::SetupStep.new(step_name) if @automated_ticket.invalid?
    end
    nil
  end

  sig { params(step: AutomatedTickets::SetupStep).void }
  def reset_to(step)
    return if @automated_ticket.ready?

    attributes_to_reset = AutomatedTicket.setup_steps.reduce([]) do |memo, (step_name, fields)|
      [*memo, *fields] if AutomatedTicket.setup_steps.keys.index(step_name) > step.index
    end
    default_attributes = AutomatedTicket.column_defaults.with_indifferent_access.slice(*attributes_to_reset)
    @automated_ticket.setup_step = step.name
    @automated_ticket.update!(default_attributes)
  end
end
