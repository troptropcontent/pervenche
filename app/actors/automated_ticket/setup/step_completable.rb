# frozen_string_literal: true

class AutomatedTicket::Setup::StepCompletable < Actor
  input :automated_ticket
  input :step
  output :step_completable
  def call
    return self.step_completable = true if step_already_completed? && !next_step_completed?
    return self.step_completable = true if previous_step_completed? && !step_already_completed?

    self.step_completable = false
  end

  private

  def step_already_completed?
    step_completed?(step)
  end

  def previous_step_completed?
    previous_step = AutomatedTicket::Setup::FindPreviousStep.call(automated_ticket:, step:).previous_step
    previous_step.nil? ? true : step_completed?(previous_step)
  end

  def next_step_completed?
    next_step = AutomatedTicket::Setup::FindNextStep.call(automated_ticket:, step:).next_step
    next_step.nil? ? true : step_completed?(next_step)
  end

  def step_completed?(step)
    AutomatedTicket::Setup::StepCompleted.call(automated_ticket:, step:).step_completed
  end
end
