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
        automated_ticket = FactoryBot.build(
          :automated_ticket,
          user_id: user.id,
          service: service,
          rate_option_client_internal_id: rate_option_client_internal_id,
          license_plate: license_plate,
          zipcode: zipcode,
          minutes: minutes,
          client_time_unit: client_time_unit,
          payment_method_client_internal_id: payment_method_client_internal_id,
          status: status
        )
        automated_ticket.save(validate: false)
        automated_ticket
      end
      let(:service) { nil }
      let(:rate_option_client_internal_id) { nil }
      let(:license_plate) { nil }
      let(:zipcode) { nil }
      let(:minutes) { nil }
      let(:client_time_unit) { nil }
      let(:payment_method_client_internal_id) { nil }
      let(:status) { 'initialized' }

      let(:automated_ticket_id) { automated_ticket.id }
      let(:id) { 'service' }
      context 'service step' do
        context 'when the step is already done' do
          let(:service) do
            service = FactoryBot.build(:service, user_id: user.id)
            service.save(validate: false)
            service
          end
          it 'redirects to the next step' do
            get path
            expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/license_plate_and_zipcode")
          end
        end

        context 'when the step not done' do
          it 'renders the correct template' do
            get path
            expect(response).to have_http_status(200)
            expect(response).to render_template('automated_tickets/setups/service')
          end
        end
      end
      context 'license_plate_and_zipcode step' do
        let(:id) { 'license_plate_and_zipcode' }
        context 'when the step is already done' do
          it 'redirects to the next step' do
            get path
            expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/rate_option")
          end
        end

        context 'when the step not done' do
          it 'renders the correct template' do
            get path
            expect(response).to have_http_status(200)
          end
        end
      end
      context 'rate_option step' do
        let(:id) { 'rate_option' }
        context 'when the step is already done' do
          it 'redirects to the next step' do
            get path
            expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/duration_and_payment_method")
          end
        end

        context 'when the step not done' do
          it 'renders the correct template' do
            get path
            expect(response).to have_http_status(200)
          end
        end
      end
      context 'duration_and_payment_method step' do
        let(:id) { 'duration_and_payment_method' }
        context 'when the step is already done' do
          it 'redirects to the index page' do
            get path
            expect(response).to redirect_to('/automated_tickets')
          end
        end

        context 'when the step not done' do
          it 'renders the correct template' do
            get path
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end
end
