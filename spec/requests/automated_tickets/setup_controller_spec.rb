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
      FactoryBot.create(:automated_ticket, :with_zipcodes, user:, service:, zipcodes: %w[75008 75017 75019],
                                                           license_plate: 'license_plate')
    end
    let(:user) { FactoryBot.create(:user) }
    let(:service) do
      service = FactoryBot.build(:service, user_id: user.id, username: 'username', password: 'password')
      service.save(validate: false)
      service
    end
    get 'show' do
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
                client_internal_id: 'a_rate_option_id',
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
