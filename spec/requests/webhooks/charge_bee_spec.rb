require 'rails_helper'

RSpec.describe 'Webhooks::ChargeBees', type: :request do
  describe 'POST /webhooks/charge_bee/:token' do
    let(:params) do
      { content: webhook_content,
        event_type: }
    end
    let(:event_type) { 'subscription_created' }
    let(:webhook_content) { { some: :data } }
    let(:token) do
      Rails.application.credentials.dig(
        :chargebee,
        ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox,
        :webhooks
      )
    end
    context 'when the token provided is correct' do
      it 'returns http success' do
        post("/webhooks/charge_bee/#{token}", params:)
        expect(response).to have_http_status(:success)
      end

      context 'when the event_type starts with subscription' do
        it 'triggers the ' do
          expect(Webhooks::ChargeBee::Handlers::SubscriptionJob).to(
            receive(:perform_async)
              .with(event_type, JSON.generate(webhook_content))
          )
          post("/webhooks/charge_bee/#{token}", params:)
          expect(response).to have_http_status(:success)
        end
      end
      context 'when the event_type starts with something not supported' do
        let(:event_type) { 'something_created' }
        it 'triggers the ' do
          expect(Webhooks::ChargeBee::Handlers::SubscriptionJob).not_to(
            receive(:perform_async)
          )
          post("/webhooks/charge_bee/#{token}", params:)
          expect(response).to have_http_status(:success)
        end
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
