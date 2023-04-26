require 'rails_helper'

RSpec.describe 'Billing::Subscriptions', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/billing/subscription/new'
      expect(response).to have_http_status(:success)
    end
  end
end
