require 'rails_helper'

RSpec.describe 'Billing::Customers', type: :request do
  path '/billing/customers/:customer_id' do
    let(:customer_id) { 'BTTzPTThSY5dNHw3' }
    get '#show' do
      let(:user) { FactoryBot.create(:user, chargebee_customer_id: customer_id) }
      it_behaves_like 'An authenticated endpoint'
      it_behaves_like 'An operationnal endpoint'
      response '200', 'OK' do
        before { sign_in user }
        let(:service) { FactoryBot.create(:service, :without_validations, user:) }
        # we have to set the id here because the vcr return a cf_holder_id = 11
        let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, id: 11, user:, service:) }
        it 'returns a 200', vcr: 'charge_bee_customer' do |example|
          run example
        end
      end
      response '404', 'Not Found' do
        before { sign_in user }
        let(:customer_id) { 'another_customer_id' }
        let(:user) { FactoryBot.create(:user, chargebee_customer_id: customer_id) }
        let(:service) { FactoryBot.create(:service, :without_validations, user:) }
        let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user:, service:) }
        it 'returns not found when the customer is not found', vcr: 'unknown_charge_bee_customer' do |example|
          run example
        end
      end
      response '403', 'Forbidden' do
        before { sign_in user }
        let(:user) { FactoryBot.create(:user, chargebee_customer_id: 'another_customer_id') }
        let(:service) { FactoryBot.create(:service, :without_validations, user:) }
        let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user:, service:) }
        it 'returns forbiden when the customer is not the current user one', vcr: 'charge_bee_customer' do |example|
          run example
        end
      end
    end
  end
end
