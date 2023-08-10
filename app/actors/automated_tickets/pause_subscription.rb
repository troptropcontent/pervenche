# frozen_string_literal: true

module AutomatedTickets
  class PauseSubscription < Actor
    input :automated_ticket, type: AutomatedTicket
    def call
      subscription = automated_ticket.subscription
      request_subscription_pause_message = subscription.pause

      fail!(error: request_subscription_pause_message) unless request_subscription_pause_message == 'OK'
    end

    def rollback
      automated_ticket.subscription.resume
    end
  end
end
