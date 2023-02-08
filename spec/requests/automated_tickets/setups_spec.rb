require 'rails_helper'

RSpec.describe 'AutomatedTickets::Setups', type: :request do
  let(:user) do
    user = FactoryBot.build(:user)
    user.save(validate: false)
    user
  end

  let(:path) { "/automated_tickets/#{automated_ticket_id}/setups/#{id}" }
  let(:automated_ticket_id) {}
  let(:id) {}
  describe 'GET /automated_tickets/:automated_ticket_id/setups/:id' do
    before do
      sign_in(user)
    end
    context '404' do
      context 'when the step does not exists' do
        let!(:automated_ticket) do
          automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
          automated_ticket.save(validate: false)
          automated_ticket
        end
        let(:automated_ticket_id) { automated_ticket.id }
        let(:id) { 'fake_step' }

        it 'returns a 404' do
          expect { get path }.to raise_error(ActionController::RoutingError)
        end
      end
      context 'when the automated_ticket does not exists' do
        let(:automated_ticket_id) { 'fake_id' }
        let(:id) { 'fake_step' }

        it 'returns a 404' do
          expect { get path }.to raise_error(ActionController::RoutingError)
        end
      end
    end
    context '403' do
      context 'when a user tries to access another user automated_ticket' do
        let!(:automated_ticket) do
          automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
          automated_ticket.save(validate: false)
          automated_ticket
        end
        let(:automated_ticket_id) { automated_ticket.id }
        let(:id) { 'service' }
        let(:another_user) { FactoryBot.create(:user, email: 'tom@example.com') }
        before do
          sign_in(another_user)
        end
        it 'returns a 403' do
          get path
          expect(response).to have_http_status(403)
        end
      end
      context 'when a user tries to setup an already set up automated_ticket' do
        let!(:automated_ticket) do
          automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil, status: :ready)
          automated_ticket.save(validate: false)
          automated_ticket
        end
        let(:automated_ticket_id) { automated_ticket.id }
        let(:id) { 'service' }
        it 'returns a 403' do
          get path
          expect(response).to have_http_status(403)
        end
      end
    end

    context '200' do
      let!(:automated_ticket) do
        automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
        automated_ticket.save(validate: false)
        automated_ticket
      end
      let(:automated_ticket_id) { automated_ticket.id }
      let(:id) { 'service' }
      context 'service step' do
        it 'returns a 403' do
          get path
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
