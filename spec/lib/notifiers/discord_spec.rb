# frozen_string_literal: true

require 'rails_helper'

module Notifiers
  RSpec.describe Discord do
    describe 'send_message' do
      context 'when PERVENCHE_DISCORD_NOTIFICATION is set' do
        before do
          allow(ENV).to receive(:fetch).with('PERVENCHE_DISCORD_NOTIFICATION', nil).and_return('true')
        end
        context 'when the channel is not setup' do
          it 'raises an error' do
            expect { described_class.send_message(:toto, 'test') }.to raise_error(KeyError, 'key not found: :toto')
          end
        end
        context 'when the channel is setup' do
          let(:expected_content) { "Pervenche (test)\n\ntest" }
          let(:webhook_url) { 'a_webhook_url' }
          it 'calls the http_client with the correct URL and content' do
            allow(Rails.application.credentials.notifiers.discord.webhooks_url).to receive(:fetch).with(:errors).and_return(webhook_url)
            expect(Http::Client).to receive(:post).with(url: webhook_url, body: { content: expected_content })
            described_class.send_message(:errors, 'test')
          end
        end
      end
      context 'when PERVENCHE_DISCORD_NOTIFICATION is not set' do
        it 'does not do anything' do
          expect(Rails.application.credentials.notifiers.discord.webhooks_url).not_to receive(:fetch).with(:errors)
          described_class.send_message(:errors, 'test')
        end
      end
    end
  end
end
