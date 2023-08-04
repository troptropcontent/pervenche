# frozen_string_literal: true

module AutomatedTickets
  class Pauser < ApplicationService
    attr_reader :automated_ticket

    def initialize(automated_ticket)
      @automated_ticket = automated_ticket
    end

    def call
      return unless automated_ticket.active

      automated_ticket.transaction(requires_new: true, joinable: false) do
        update_active_attribute!
        pause_subscription!
      end
    end

    private

    def update_active_attribute!
      automated_ticket.update!(active: false)
    end

    def pause_subscription!
      subscription = automated_ticket.subscription
      request_subscription_pause_message = subscription.pause
      return if request_subscription_pause_message == 'OK'

      raise_and_notify_error(request_subscription_pause_message)
    end

    def raise_and_notify_error(request_subscription_pause_message)
      ActiveSupport::Notifications.instrument 'charge_bee.subscription_pause_error', {
        message: request_subscription_pause_message,
        automated_ticket_id: automated_ticket.id,
        user_email: automated_ticket.user.email
      }
      raise Billing::Errors::UnprocessableEntity, request_subscription_pause_message
    end
  end
end
