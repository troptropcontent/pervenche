# frozen_string_literal: true
# typed: strict

class AutomatedTickets::Setup
  extend T::Sig
  sig { params(automated_ticket: AutomatedTicket, step: Symbol).void }
  def initialize(automated_ticket, step)
    @automated_ticket = automated_ticket
    @step = step
  end

  sig { params(step: T.any(Symbol, String), previous_step: T.nilable(Symbol)).returns(String) }
  def path_for(step:, previous_step: nil)
    AutomatedTicket::Setup::FindPath.call(automated_ticket: @automated_ticket, step: step.to_sym, previous_step:).path
  end

  sig { params(step: T.any(Symbol, String)).returns(T::Boolean) }
  def step_completable?(step)
    AutomatedTicket::Setup::StepCompletable.call(automated_ticket: @automated_ticket,
                                                 step: step.to_sym).step_completable
  end
end
