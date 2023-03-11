# frozen_string_literal: true

class AutomatedTicket::Setup::Updater < Actor
  input :step
  input :params
  input :automated_ticket

  play UpdateAutomatedTicket
  play CompleteUpcomingSteps, 
       FindNextStep, 
       LoadData,
       if: -> actor { actor.automated_ticket.valid? } 
end
