# frozen_string_literal: true
# typed: strict

class AutomatedTickets::SetupStep
  extend T::Sig
  include Rails.application.routes.url_helpers
  include AutomatedTickets::AutoCompletable

  class << self
    extend T::Sig

    sig { returns(T::Array[AutomatedTickets::SetupStep]) }
    def steps
      AutomatedTicket.setup_steps.keys.map do |step_name|
        new(step_name)
      end
    end

    sig { params(automated_ticket: AutomatedTicket).returns(T.nilable(AutomatedTickets::SetupStep)) }
    def current_step(automated_ticket)
      steps.each do |step|
        return step if step.uncompleted?(automated_ticket)
      end
      nil
    end
    alias next_completable_step current_step

    sig { params(automated_ticket: AutomatedTicket).returns(T.nilable(AutomatedTickets::SetupStep)) }
    def last_completed_step(automated_ticket)
      first_step = T.must(steps.first)
      return if first_step.uncompleted?(automated_ticket)

      last_completed_step = first_step

      steps.each do |step|
        break if step.uncompleted?(automated_ticket)

        last_completed_step = step
      end

      last_completed_step
    end

    sig { params(automated_ticket: AutomatedTicket).returns(T.nilable(AutomatedTickets::SetupStep)) }
    def last_completable_step(automated_ticket)
      last_completed_step = last_completed_step(automated_ticket)
      return if last_completed_step.nil?

      completed_steps = T.must(steps[0..last_completed_step.index])
      return if completed_steps.length == 1

      completed_steps.reverse.each do |step|
        return step if step.required?(automated_ticket) && step.not_auto_completable?(automated_ticket)
      end
      nil
    end
  end

  sig { params(step_name: Symbol).void }
  def initialize(step_name)
    @step_name = step_name
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def default_attributes
    attributes = T.must(AutomatedTicket.setup_steps[name])
    AutomatedTicket.column_defaults.with_indifferent_access.slice(*attributes)
  end

  sig { params(another_step: AutomatedTickets::SetupStep).returns(T::Boolean) }
  def before?(another_step)
    self < another_step
  end

  sig { params(other: AutomatedTickets::SetupStep).returns(T::Boolean) }
  def <(other)
    index < other.index
  end

  sig { returns(Integer) }
  def index
    AutomatedTicket.setup_steps.keys.index(step_name)
  end
  alias step_index index

  sig { params(automated_ticket: T.any(Integer, AutomatedTicket)).returns(String) }
  def show_path(automated_ticket)
    automated_ticket_id = T.let(automated_ticket.is_a?(Integer) ? automated_ticket : automated_ticket.id, Integer)

    automated_ticket_setup_path(automated_ticket_id:, step_name: name)
  end

  sig { params(automated_ticket: T.any(Integer, AutomatedTicket)).returns(String) }
  def edit_path(automated_ticket)
    automated_ticket_id = T.let(automated_ticket.is_a?(Integer) ? automated_ticket : automated_ticket.id, Integer)

    edit_automated_ticket_setup_path(automated_ticket_id:, step_name: name)
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

  sig { params(automated_ticket: AutomatedTicket).returns(T::Boolean) }
  def uncompleted?(automated_ticket)
    !completed?(automated_ticket)
  end

  sig { returns(T.nilable(AutomatedTickets::SetupStep)) }
  def next
    next_step_name = AutomatedTicket.setup_steps.keys[step_index + 1]
    return AutomatedTickets::SetupStep.new(next_step_name) if next_step_name
  end

  sig { params(automated_ticket: AutomatedTicket).returns(T::Boolean) }
  def auto_completable?(automated_ticket)
    !auto_completable_attributes(name, automated_ticket).empty?
  end

  sig { params(automated_ticket: AutomatedTicket).returns(T::Boolean) }
  def not_auto_completable?(automated_ticket)
    auto_completable_attributes(name, automated_ticket).empty?
  end

  sig { params(other: T.untyped).returns(T::Boolean) }
  def ==(other)
    return false unless other.is_a?(AutomatedTickets::SetupStep)

    name == other.name
  end

  sig { params(automated_ticket: AutomatedTicket).returns(T::Boolean) }
  def required?(automated_ticket)
    automated_ticket.assign_attributes(default_attributes)
    uncompleted?(automated_ticket)
  end
end
