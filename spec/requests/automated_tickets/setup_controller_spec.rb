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

  path '/automated_tickets/:automated_ticket_id/setup/:step_name' do
    let(:automated_ticket_id) { automated_ticket.id }
    let(:step_name) { :rate_option }
    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, automated_ticket_setup_step, user:, service:, zipcodes: %w[75008 75017 75019],
                                                                        license_plate: 'license_plate')
    end
    let!(:automated_ticket_setup_step) { :with_zipcodes }
    let(:user) { FactoryBot.create(:user) }
    let(:service) do
      service = FactoryBot.build(:service, user_id: user.id, username: 'username', password: 'password')
      service.save(validate: false)
      service
    end
    get 'show' do
      it_behaves_like 'An authenticated endpoint'

      response '200', 'OK' do
        include_context 'stubed pay_by_phone auth'
        include_context 'stubed pay_by_phone account_id'

        before { sign_in user }

        describe 'service' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'localisation' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'kind' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'vehicle' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'zipcodes' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'rate_option' do
          include_context 'stubed pay_by_phone rate_options', '75008', 'license_plate'
          include_context 'stubed pay_by_phone quote', '75008', 'license_plate'
          include_context 'stubed pay_by_phone rate_options', '75017', 'license_plate'
          include_context 'stubed pay_by_phone quote', '75017', 'license_plate'
          include_context 'stubed pay_by_phone rate_options', '75019', 'license_plate'
          include_context 'stubed pay_by_phone quote', '75019', 'license_plate'

          let(:step_name) { :rate_option }
          context 'when the step is completable' do
            it 'return the setup step page' do |example|
              run example
              expect(response).to render_template 'automated_tickets/setup/rate_option'
              expect(assigns(:rate_options)).to eq([ParkingTicket::Clients::Models::RateOption.new(
                accepted_time_units: ['days'],
                client_internal_id: 'a_res_rate_option_id',
                free: true, name: 'stubed_name',
                type: 'RES'
              )])
            end
          end
        end
        describe 'weekdays' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'payment_methods' do
          it 'renders the relevant view with the relevant variables'
        end
        describe 'subscription' do
          it 'renders the relevant view with the relevant variables'
        end
      end

      response '302', 'Found' do
        before { sign_in user }
        context 'when the step is already completed' do
          context 'when there is a step completable' do
            describe 'localisation' do
              it 'redirects to the next completable step show'
            end
            describe 'kind' do
              it 'redirects to the next completable step show'
            end
            describe 'vehicle' do
              it 'redirects to the next completable step show'
            end
            describe 'zipcodes' do
              it 'redirects to the next completable step show'
            end
            describe 'rate_option' do
              let(:step_name) { :rate_option }
              let!(:automated_ticket) do
                FactoryBot.create(:automated_ticket, :with_weekdays, user:, service:)
              end
              context 'when the step is not completable' do
                it 'redirects to the next completable step show (payment_methods here)' do |example|
                  run example
                  expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setup/payment_methods")
                end
              end
            end
            describe 'weekdays' do
              it 'redirects to the next completable step show'
            end
            describe 'payment_methods' do
              it 'redirects to the next completable step show'
            end
            describe 'subscription' do
              it 'redirects to the next completable step show'
            end

            it 'redirects to the next completable step show' do
            end
          end
          context 'when the setup is finished and there is no more step completable' do
            it 'redirect to root path' do
            end
          end
        end
      end
    end

    put 'update' do
      it_behaves_like 'An authenticated endpoint'
      response '302', 'Found' do
        before { sign_in user }
        include_context 'stubed pay_by_phone auth'
        include_context 'stubed pay_by_phone account_id'

        context 'when the updated automated_ticket is valid' do
          context 'when there is a next step to complete' do
            let(:step_name) { :vehicle }
            let!(:automated_ticket_setup_step) { :with_kind }
            params do
              {
                automated_ticket: {
                  license_plate: 'a_license_plate',
                  vehicle_type: 'car'
                }
              }
            end

            it 'redirect to the next step' do |example|
              run example
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setup/zipcodes")
            end
          end
          context 'when there is no more step to complete' do
            let(:step_name) { :subscription }
            let!(:automated_ticket_setup_step) { :with_payment_methods }
            params do
              {
                automated_ticket: {
                  charge_bee_subscription_id: 'a_charge_bee_subscription_id'
                }
              }
            end

            it 'redirect to the root' do |example|
              run example
              expect(response).to redirect_to('/')
            end
          end
        end
      end
      response '422', 'Unprocessable Entity' do
        before { sign_in user }
        include_context 'stubed pay_by_phone auth'
        include_context 'stubed pay_by_phone account_id'
        let(:step_name) { :zipcodes }
        let!(:automated_ticket_setup_step) { :with_vehicle }
        params do
          {
            automated_ticket: {
              zipcodes: []
            }
          }
        end
        context 'when the updated automated_ticket is not valid' do
          it 'returns a 422 with the errors in a flash' do |example|
            run example
            expect(response.body).to include('Aucun code zone selectionné')
          end
        end
      end

      response '400', 'Bad Request' do
        before { sign_in user }
        context 'when no automated_ticket are provided' do
          it 'returns a 400 bad request' do |example|
            run example
            response_body = JSON.parse(response.body)
            expect(response_body['message']).to eq('Le paramètre automated_ticket est manquant')
          end
        end
      end
    end
  end

  path '/automated_tickets/:automated_ticket_id/setup/:step_name/edit' do
    let(:automated_ticket_id) { automated_ticket.id }
    let(:step_name) { :rate_option }
    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, :with_vehicle, user:, service:)
    end
    let(:user) { FactoryBot.create(:user) }
    let(:service) do
      service = FactoryBot.build(:service, user_id: user.id, username: 'username', password: 'password')
      service.save(validate: false)
      service
    end

    get 'edit' do
      include_context 'stubed pay_by_phone auth'
      include_context 'stubed pay_by_phone account_id'
      it_behaves_like 'An authenticated endpoint'

      response '400', 'Bad Request' do
        before { sign_in user }
        describe 'when the step is not completed' do
          let(:step_name) { :zipcodes }
          it 'returns a 422' do |example|
            run example
          end
        end
      end

      response '200', 'OK' do
        before { sign_in user }
        include_context 'stubed pay_by_phone vehicles'

        describe 'when the step is completed' do
          let(:step_name) { :vehicle }
          it 'returns a the setup up view' do |example|
            run example
            expect(response).to render_template 'automated_tickets/setup/vehicle'
            expect(assigns(:vehicles)).to eq([ParkingTicket::Clients::Models::Vehicle.new(
              client_internal_id: '1111111111',
              license_plate: 'AA123BB',
              vehicle_description: nil,
              vehicle_type: 'electric_motorcycle'
            )])
          end
        end
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
            expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setup/vehicle/edit")
          end
        end
      end
    end
  end
end
