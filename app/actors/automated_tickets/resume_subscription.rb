# frozen_string_literal: true

module AutomatedTickets
  class ResumeSubscription < Actor
    input :automated_ticket, type: AutomatedTicket
    def call
      subscription = automated_ticket.subscription
      customer = subscription.customer
      payment_method = customer.payment_method

      fail!(error: "Customer's payment method missing or invalid") unless payment_method.status == 'valid'

      request_subscription_resume_message = subscription.resume

      fail!(error: request_subscription_resume_message) unless request_subscription_resume_message == 'OK'
    end

    def rollback
      automated_ticket.subscription.pause
    end
  end
end
