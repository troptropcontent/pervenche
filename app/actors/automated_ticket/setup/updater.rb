# frozen_string_literal: true

module AutomatedTicket::Setup
  class Updater < Actor
    input :step
    input :params
    input :automated_ticket

    play UpdateAutomatedTicket
    play CompleteAlreadyCompletableSteps,
         FindNextStep,
         LoadData,
         if: ->(actor) { actor.automated_ticket.valid? }
  end
end
