# frozen_string_literal: true
# typed: true

class AutomatedTicket::Setup::CompleteAlreadyCompletableSteps < Actor
  input :automated_ticket
  output :automated_ticket
  def call
    return if setup_already_completed?

    next_completable_step = find_uncompleted_and_completable_step
    until next_completable_step.nil?
      automated_ticket.save!
      next_completable_step = find_uncompleted_and_completable_step
    end
  end

  private

  def find_next_uncompleted_step
    AutomatedTicket.setup_steps.keys.find do |step|
      automated_ticket.setup_step = step
      automated_ticket.invalid?
    end
  end

  def find_uncompleted_and_completable_step
    next_step = AutomatedTicket.setup_steps.keys.find do |step_name|
      automated_ticket.setup_step = step_name
      automated_ticket.invalid?
    end

    next_step if completable_step?(next_step)
  end

  def completable_step?(step)
    step = AutomatedTickets::SetupStep.new(step)
    auto_completable_attributes = step.auto_completable_attributes(step.name, automated_ticket)
    return false if auto_completable_attributes.empty?

    automated_ticket.assign_attributes(auto_completable_attributes)

    automated_ticket.valid?
  end

  def first_uncompleted_step
    AutomatedTicket.setup_steps.keys.find do |step|
      automated_ticket.setup_step = step
      automated_ticket.invalid?
    end
  end

  def setup_already_completed?
    result = false
    automated_ticket.tap do |automated_ticket|
      automated_ticket.setup_step = nil
      result = automated_ticket.valid?
    end
    result
  end
end
