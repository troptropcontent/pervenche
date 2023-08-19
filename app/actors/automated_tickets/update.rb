# frozen_string_literal: true

module AutomatedTickets
  class Update < Actor
    input :automated_ticket, type: AutomatedTicket
    input :automated_ticket_params, type: ActionController::Parameters

    play UseParams
    play PauseSubscription, if: lambda { |actor|
                                  actor.automated_ticket.charge_bee_subscription_id && actor.saved_changes['active'] == [true, false]
                                }
    play UpdateLastUpdatedAt, if: ->(actor) { actor.saved_changes['active'] == [false, true] }
    play ResumeSubscription, if: lambda { |actor|
                                   actor.automated_ticket.charge_bee_subscription_id && actor.saved_changes['active'] == [false, true]
                                 }
  end
end
