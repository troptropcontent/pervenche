# frozen_string_literal: true
# typed: strict

module Billable
  module Webhook
    module Mixins
      module Subscription
        module TrialEndReminder
          extend T::Sig
          sig { params(content: T::Hash[String, T.untyped]).void }
          def process_trial_end_reminder_webhook(content)
            automated_ticket = AutomatedTicket.find(content.dig('subscription', 'cf_automated_ticket_id'))
            payment_method_status = content.dig('customer', 'card_status')
            customer_id = content.dig('customer', 'id')
            if payment_method_status == 'no_card'
              notify_end_of_trial_and_request_payment_method_update(automated_ticket, customer_id)
            elsif payment_method_status == 'valid'
              notify_end_of_trial(automated_ticket)
            end
          end

          private

          sig { params(automated_ticket: AutomatedTicket, customer_id: String).void }
          def notify_end_of_trial_and_request_payment_method_update(automated_ticket, customer_id)
            AutomatedTicketMailer.trial_period_ends_soon(
              to: automated_ticket.user.email,
              license_plate: automated_ticket.license_plate,
              update_payment_method_url: retrieve_update_payment_method_hosted_page_url(customer_id)
            ).deliver_later
          end

          sig { params(automated_ticket: AutomatedTicket).void }
          def notify_end_of_trial(automated_ticket)
            # to implement here a new email to inform the user that he will soon be charged
          end

          sig { params(customer_id: String).returns(String) }
          def retrieve_update_payment_method_hosted_page_url(customer_id)
            T.must(Billable::Customer.update_payment_method_hosted_page_url(customer_id, redirect_url: find_root_url))
          end

          sig { returns(String) }
          def find_root_url
            Rails.application.routes.url_helpers.root_url(host: Pervenche::HOSTS[Rails.env.to_sym])
          end
        end
      end
    end
  end
end
