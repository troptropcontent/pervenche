require 'rails_helper'

RSpec.describe 'Billing::Subscriptions', type: :request do
  path '/billing/subscriptions' do
    get '#index' do
      let(:user) { FactoryBot.create(:user, roles: user_roles) }
      let(:user_roles) { %w[customer admin] }
      it_behaves_like 'An authenticated endpoint'
      it_behaves_like 'An operationnal endpoint'
      response '200', 'OK' do
        before { sign_in user }
        let(:service) { FactoryBot.create(:service, :without_validations, user:) }
        let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user:, service:) }
        it 'returns a 200', vcr: 'charge_bee_customer' do |example|
          run example
        end
      end
      response '403', 'Forbidden' do
        let(:user_roles) { %w[customer] }
        before { sign_in user }
        let(:user) { FactoryBot.create(:user, chargebee_customer_id: 'another_customer_id') }
        let(:service) { FactoryBot.create(:service, :without_validations, user:) }
        let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user:, service:) }
        it 'returns forbiden when the customer have not the admin role' do |example|
          run example
        end
      end
    end
  end
end
