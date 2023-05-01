require 'rails_helper'

RSpec.describe 'Webhooks::ChargeBees', type: :request do
  describe 'POST /webhooks/charge_bee/:token' do
    let(:token) do
      Rails.application.credentials.dig(
        :chargebee,
        ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox,
        :webhooks
      )
    end
    context 'when the token provided is correct' do
      it 'returns http success' do
        post "/webhooks/charge_bee/#{token}"
        expect(response).to have_http_status(:success)
      end
    end
    context 'when the token provided is not correct' do
      let(:token) { 'a_fake_token' }
      it 'returns http success' do
        post "/webhooks/charge_bee/#{token}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
