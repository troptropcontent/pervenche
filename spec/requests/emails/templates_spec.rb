require 'rails_helper'

module Emails
  RSpec.describe TemplatesController, type: :request do
    describe 'GET /index' do
      it 'returns http success'
    end

    describe 'GET /show' do
      it 'returns http success'
    end

    path '/emails/templates/:template_id/deliver' do
      let(:template_id) { 'd-82716949fa6a46e7992c36b5939743f1' }
      let(:user) { FactoryBot.create(:user, roles: user_roles) }
      let(:user_roles) { %w[admin] }

      post '#deliver' do
        response '204', 'No Content' do
          before { sign_in user }
          params do
            { template: {
              to: 'tomecrepont@gmail.com',
              template_data: {
                account_created_at: '12-05'
              }
            } }
          end
          it 'works' do |example|
            expect do
              run example
            end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
          end
        end
        response '404', 'Not Found' do
          let(:template_id) { 'toto' }
          before { sign_in user }
          params do
            { template: {
              to: 'tomecrepont@gmail.com',
              template_data: {
                account_created_at: '12-05'
              }
            } }
          end
          context 'when the template id is not registered' do
            it 'returns a 404' do |example|
              run example
            end
          end
        end
      end
    end
  end
end
