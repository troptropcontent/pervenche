# frozen_string_literal: true

module AutomatedTickets
  class Resumer < ApplicationService
    attr_reader :automated_ticket

    def initialize(automated_ticket)
      @automated_ticket = automated_ticket
    end

    def call
      subscription = automated_ticket.subscription
      request_subscription_resume_message = subscription.resume
      return if request_subscription_resume_message == 'OK'

      raise_and_notify_error(request_subscription_resume_message)
    end

    private

    def raise_and_notify_error(request_subscription_resume_message)
      ActiveSupport::Notifications.instrument 'charge_bee.subscription_resume_error', {
        message: request_subscription_resume_message,
        automated_ticket_id: automated_ticket.id,
        user_email: automated_ticket.user.email
      }
      raise Billing::Errors::UnprocessableEntity, request_subscription_resume_message
    end
  end
end
