# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AutomatedTickets', type: :request do
  describe '/automated_tickets' do
    context 'GET' do
      describe 'automated_tickets#index' do
        it 'returns the index'
      end
    end
  end

  path '/automated_tickets/export.csv' do
    get '#export' do
      let(:user) { FactoryBot.create(:user, roles: user_roles) }
      let(:user_roles) { ['customer'] }
      it_behaves_like 'An authenticated endpoint'
      response '200', 'OK' do
        before { sign_in user }
        let(:user_roles) { ['admin'] }
        context 'when there is no automated_tickets' do
          it 'returns an empty csv' do |example|
            run example
            expect(response.body).to eq("\nUtilisateur id;Client id;Utilisateur email;Ticket id;Ticket Codes zones;Ticket immatriculation;Ticket kind;Abonnement status;Abonnement motif annul;Abonnement fin éssai;Abonnement prochaine facture;Abonnement date annul;Abonnement date départ;Abonnement montant\n")
          end
        end
        context 'when there is some automated_tickets' do
          let(:another_user) { FactoryBot.create(:user, chargebee_customer_id: 'another_customer_id') }
          let(:service) { FactoryBot.create(:service, :without_validations, user: another_user) }
          let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user: another_user, service:, charge_bee_subscription_id: 'BTcd4bTi6ndWBIYX') }
          it 'returns an empty csv', :vcr do |example|
            run example
            expect(response.body).to eq("\nUtilisateur id;Client id;Utilisateur email;Ticket id;Ticket Codes zones;Ticket immatriculation;Ticket kind;Abonnement status;Abonnement motif annul;Abonnement fin éssai;Abonnement prochaine facture;Abonnement date annul;Abonnement date départ;Abonnement montant\n  #{another_user.id};another_customer_id;#{another_user.email};#{automated_ticket.id};75018, 75019 et 75020;CL12345KK;electric_motorcycle;in_trial;;2023-07-09T14:32:44+00:00;2023-07-09T14:32:44+00:00;;2023-06-24T14:32:44+00:00;9,00 €\n")
          end
        end
      end
      response '403', 'Forbidden' do
        before { sign_in user }
        context 'when the user is not admin' do
          it 'returns a 403 forbiden' do |example|
            run example
          end
        end
      end
    end
  end

  path '/automated_tickets/:id' do
    let(:id) { automated_ticket.id }
    let!(:automated_ticket) do
      FactoryBot.create(:automated_ticket, :set_up, user:, service:, active: initial_automated_ticket_active_attribute, charge_bee_subscription_id: 'BTcd4sThFVEMHRSz')
    end
    let(:initial_automated_ticket_active_attribute) { true }
    let(:user) { FactoryBot.create(:user) }
    let(:service) { FactoryBot.create(:service, :without_validations, user:) }

    put '#update' do
      it_behaves_like 'An authenticated endpoint'

      response '204', 'No Content' do
        before { sign_in user }
        context 'when the active attribute is updated' do
          context 'when the attribute is updated from true to false' do
            let(:initial_automated_ticket_active_attribute) { true }
            params { { automated_ticket: { active: false } } }
            it 'updates the active attribute and pauses the subscription', vcr: true do |example|
              expect(Billable::Clients::ChargeBee::Subscription).to receive(:pause).with('BTcd4sThFVEMHRSz').and_call_original
              expect { run example }.to change { automated_ticket.reload.active }.from(true).to(false)
            end
          end
          context 'when the attribute is updated from false to true' do
            let(:initial_automated_ticket_active_attribute) { false }
            params { { automated_ticket: { active: true } } }
            it 'updates the active attribute and resumes the subscription', vcr: true do |example|
              expect(Billable::Clients::ChargeBee::Subscription).to receive(:resume).with('BTcd4sThFVEMHRSz').and_call_original
              expect { run example }.to change { automated_ticket.reload.active }.from(false).to(true)
            end
          end
        end
      end
      response '422', 'Unprocessable Entity' do
        before { sign_in user }
        context 'when the active attribute is updated' do
          context 'when the attribute is updated from true to false but the subscription can not be paused' do
            let(:initial_automated_ticket_active_attribute) { true }
            params { { automated_ticket: { active: false } } }
            it 'does not update the active attribute', vcr: true do |example|
              expect(Billable::Clients::ChargeBee::Subscription).to receive(:pause).with('BTcd4sThFVEMHRSz').and_call_original
              expect { run example }.not_to(change { automated_ticket.reload.active })
            end
          end
          context 'when the attribute is updated from false to true but the subscription can not be resumed' do
            let(:initial_automated_ticket_active_attribute) { false }
            params { { automated_ticket: { active: true } } }
            it 'updates the active attribute and pauses the subscription', vcr: true do |example|
              expect(Billable::Clients::ChargeBee::Subscription).to receive(:resume).with('BTcd4sThFVEMHRSz').and_call_original
              expect { run example }.not_to(change { automated_ticket.reload.active })
            end
          end
        end
      end
    end
  end

  describe '/automated_tickets/new' do
    context 'GET' do
      describe 'automated_tickets#new' do
        it 'returns the automated_ticket wizard'
      end
    end
  end
end
