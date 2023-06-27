require 'rails_helper'

RSpec.describe 'Webhooks::Billing', type: :request do
  Sidekiq::Testing.fake!
  path '/webhooks/billing/:token' do
    let(:token) { Billable.webhook_token }
    post 'handle' do
      response '200', 'OK' do
        params do
          { event_type: 'payment_event',
            content: { some: 'content' } }
        end

        describe 'webhook type' do
          context 'when the web hook type starts with payment' do
            let(:expected_job_arguments)  do
              [
                ['payment_event', '{"some":"content"}']
              ]
            end
            it 'triggers a SubscriptionJob' do |example|
              expect { run example }.to change(Billing::Webhook::PaymentJob.jobs, :size).by(1)
              enqueued_job_arguments = Billing::Webhook::PaymentJob.jobs.pluck('args')
              expect(enqueued_job_arguments).to contain_exactly(*expected_job_arguments)
            end
          end
          context 'when the web hook type starts with something else' do
            params do
              { event_type: 'some_event',
                content: { some: 'content' } }
            end
            it 'does not do anything' do |example|
              expect { run example }.not_to change(Sidekiq::Queues['default'], :size)
            end
          end
        end
      end

      response '401', 'Unauthorized' do
        let(:token) { 'toto' }
        context 'when the token is not valid' do
          it 'return a 403' do |example|
            run example
          end
        end
      end
    end
  end
end
