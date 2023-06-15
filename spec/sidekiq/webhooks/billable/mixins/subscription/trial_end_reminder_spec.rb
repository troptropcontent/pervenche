# frozen_string_literal: true

require 'rails_helper'
module Billable
  module Webhook
    module Mixins
      module Subscription
        RSpec.describe TrialEndReminder do
          include TrialEndReminder
          describe 'process_trial_end_reminder_webhook(content)' do
            let!(:automated_ticket) do
              FactoryBot.create(:automated_ticket, :set_up, user:, service:, license_plate: 'a_license_plate', charge_bee_subscription_id: 'BTM8jcTfo0J6IVpC')
            end
            let(:user) do
              FactoryBot.create(:user,
                                email: 'toto@example.com', chargebee_customer_id: 'BTM8jcTfo0J6IVpC')
            end
            let(:service) do
              FactoryBot.create(:service,
                                :without_validations, user_id: user.id)
            end
            let(:content) do
              {
                'subscription' => {
                  'id' => 'BTM8jcTfo0J6IVpC',
                  'cf_automated_ticket_id' => automated_ticket.id
                },
                'customer' => {
                  'id' => 'BTM8jcTfo0J6IVpC',
                  'card_status' => 'no_card'
                }
              }
            end

            let(:expected_mailer_arguments) do
              {
                to: 'toto@example.com',
                license_plate: 'a_license_plate',
                update_payment_method_url: 'an_url_to_the_hosted_page_to_manage_payments'
              }
            end

            context 'when the user have not setup its credit card yet' do
              it 'sends an email to the user to ask him to update its paiment method' do
                message_delivery = instance_double(ActionMailer::MessageDelivery)
                allow(Billable::Customer).to receive(:update_payment_method_hosted_page_url).with('BTM8jcTfo0J6IVpC').and_return('an_url_to_the_hosted_page_to_manage_payments')
                allow(AutomatedTicketMailer).to receive(:trial_period_ends_soon).with(expected_mailer_arguments).and_return(message_delivery)
                expect(message_delivery).to receive(:deliver_later)
                process_trial_end_reminder_webhook(content)
              end
            end
            context 'when the user have already setup its credit card' do
              it 'sends an email to the user to let him know that he will soon be charged'
            end
          end
        end
      end
    end
  end
end
