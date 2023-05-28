# frozen_string_literal: true
# typed: strict

class AutomatedTickets::SetupStep
  extend T::Sig
  include Rails.application.routes.url_helpers

  sig { params(step_name: Symbol).void }
  def initialize(step_name)
    @step_name = step_name
  end

  sig { params(another_step: AutomatedTickets::SetupStep).returns(T::Boolean) }
  def before?(another_step)
    index < another_step.index
  end

  sig { returns(Integer) }
  def index
    AutomatedTicket.setup_steps.keys.index(@step_name)
  end

  sig { params(automated_ticket: T.any(Integer, AutomatedTicket)).returns(String) }
  def show_path(automated_ticket)
    automated_ticket_id = T.let(automated_ticket.is_a?(Integer) ? automated_ticket : automated_ticket.id, Integer)

    automated_ticket_setup_path(automated_ticket_id:, step_name: name)
  end

  sig { returns(Symbol) }
  def name
    @step_name
  end
  alias step_name name

  sig { returns(String) }
  def to_s
    @step_name.to_s
  end

  sig { params(automated_ticket: AutomatedTicket).returns(T::Boolean) }
  def completable?(automated_ticket)
    AutomatedTicket::Setup::StepCompletable.call(
      automated_ticket:,
      step: name
    ).step_completable
  end

  sig { params(automated_ticket: AutomatedTicket).returns(T::Boolean) }
  def completed?(automated_ticket)
    automated_ticket.setup_step = step_name
    automated_ticket.valid?
  end
end
