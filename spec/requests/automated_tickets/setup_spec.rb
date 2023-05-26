# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AutomatedTickets::Setups', type: :request do
  describe '/automated_tickets/:automated_ticket_id/setup/:step_name/edit' do
    context 'GET' do
      describe 'automated_tickets/setup#edit' do
        it 'show the edit version of the step'
      end
    end
  end
  describe '/automated_tickets/:automated_ticket_id/setup/:step_name' do
    context 'GET' do
      describe 'automated_tickets/setup#show' do
        it 'show the setup version of the step'
      end
    end
    context 'PATCH' do
      describe 'automated_tickets/setup#update' do
        it 'updates the automated ticket and redirect to the relevant page'
      end
    end
    context 'PUT' do
      describe 'automated_tickets/setup#update' do
        it 'updates the automated ticket and redirect to the relevant page'
      end
    end
  end

  path '/automated_tickets/:automated_ticket_id/setup/:step_name/reset' do
    let(:automated_ticket_id) { automated_ticket.id }
    let(:step_name) { :vehicle }

    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, :with_zipcodes, user:, service:)
    end
    let(:user) { FactoryBot.create(:user) }
    let(:service) do
      service = FactoryBot.build(:service, user_id: user.id)
      service.save(validate: false)
      service
    end
    put 'reset' do
      it_behaves_like 'An authenticated endpoint'

      response '400', 'Bad Request' do
        before { sign_in user }
        describe 'when the step targeted is a step that is after the current step' do
          let(:step_name) { :weekdays }
          it 'returns a 422' do |example|
            run example
          end
        end
      end

      response '403', 'Forbidden' do
        before { sign_in user }
        describe 'when the automated ticket does not belong to the current user' do
          let(:another_user) { FactoryBot.create(:user, email: 'toto@example.com') }
          let!(:automated_ticket) do
            FactoryBot.create(:automated_ticket, :with_zipcodes, user: another_user, service:)
          end
          it 'returns a 403' do |example|
            run example
          end
        end
        describe 'when the automated ticket is ready' do
          let!(:automated_ticket) do
            FactoryBot.create(:automated_ticket, :set_up, user:, service:)
          end
          it 'returns a 403' do |example|
            run example
          end
        end
      end

      response '302', 'Found' do
        before { sign_in user }
        describe 'when the params are correct' do
          it 'reset the automated ticket to the requested step and redirect to the requested step' do |example|
            run example
            expect(automated_ticket.reload.zipcodes).to eq([])
          end
        end
      end
    end
  end
end
