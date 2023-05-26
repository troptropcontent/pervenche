# frozen_string_literal: true
# typed: strict

class AutomatedTickets::Setup
  extend T::Sig
  sig { params(automated_ticket: AutomatedTicket).void }
  def initialize(automated_ticket)
    @automated_ticket = automated_ticket
  end

  sig { params(step: T.any(Symbol, String), previous_step:).returns(String) }
  def path_for(step:, previous_step: nil)
    AutomatedTicket::Setup::FindPath.call(automated_ticket: @automated_ticket, step: step.to_sym, previous_step:).path
  end

  sig { params(step: T.any(Symbol, String)).returns(T::Boolean) }
  def step_completable?(step)
    AutomatedTicket::Setup::StepCompletable.call(automated_ticket: @automated_ticket,
                                                 step: step.to_sym).step_completable
  end

  sig { params(target_step: T.any(Symbol, String)).returns(T::Boolean) }
  def step_before?(target_step)
    AutomatedTicket.setup_steps.keys.index(target_step.to_sym) < AutomatedTicket.setup_steps.keys.index(@step)
  end

  sig { returns(AutomatedTickets::SetupStep) }
  def last_completed_step
    last_completed_step_instance = AutomatedTickets::SetupStep.new(@automated_ticket, :null)
    AutomatedTicket.setup_steps.keys.each do |step_name|
      @automated_ticket.setup_step = step_name
      break if @automated_ticket.invalid?

      last_completed_step_instance = AutomatedTickets::SetupStep.new(@automated_ticket, step_name)
    end
    last_completed_step_instance
  end
end
