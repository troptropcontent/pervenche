require 'rails_helper'

module Emails
  RSpec.describe TemplatesController, type: :request do
    describe 'GET /index' do
      it 'returns http success' do
        get '/emails/templates/index'
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET /show' do
      it 'returns http success' do
        get '/emails/templates/show'
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET /deliver' do
      it 'returns http success' do
        get '/emails/templates/deliver'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
