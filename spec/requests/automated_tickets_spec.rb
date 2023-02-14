require 'rails_helper'

RSpec.describe 'AutomatedTickets', type: :request do
  describe 'GET /automated_tickets/new' do
    it 'returns http success' do
      get '/automated_tickets/new'
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET /automated_tickets/new' do
    it 'returns http success' do
      get '/automated_tickets/new'
      expect(response).to have_http_status(:success)
    end
  end
  describe 'PUT /automated_tickets' do
    it 'returns http success' do
      get '/automated_tickets/new'
      expect(response).to have_http_status(:success)
    end
  end
end
