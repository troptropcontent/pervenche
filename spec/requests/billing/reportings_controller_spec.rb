require 'rails_helper'

RSpec.describe 'Billing::Reportings', type: :request do
  describe 'GET /subscription_statuses' do
    it 'returns http success' do
      get '/billing/reportings/subscription_statuses'
      expect(response).to have_http_status(:success)
    end
  end
end
