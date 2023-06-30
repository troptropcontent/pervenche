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
            expect response.body.to eq("\nUtilisateur id;Client id;Utilisateur email;Ticket Codes zones;Ticket immatriculation;Ticket kind;Abonnement status;Abonnement motif annul;Abonnement fin éssai;Abonnement prochaine facture;Abonnement date annul;Abonnement date départ;Abonnement montant\n")
          end
        end
        context 'when there is some automated_tickets' do
          let(:another_user) { FactoryBot.create(:user, chargebee_customer_id: 'another_customer_id') }
          let(:service) { FactoryBot.create(:service, :without_validations, user: another_user) }
          let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user: another_user, service:, charge_bee_subscription_id: 'BTcd4bTi6ndWBIYX') }
          it 'returns an empty csv', :vcr do |example|
            run example
            expect(response.body).to eq("\nUtilisateur id;Client id;Utilisateur email;Ticket id;Ticket Codes zones;Ticket immatriculation;Ticket kind;Abonnement status;Abonnement motif annul;Abonnement fin éssai;Abonnement prochaine facture;Abonnement date annul;Abonnement date départ;Abonnement montant\n  #{another_user.id};another_customer_id;person2@example.com;#{automated_ticket.id};75018, 75019 et 75020;CL12345KK;electric_motorcycle;in_trial;;2023-07-09T14:32:44+00:00;2023-07-09T14:32:44+00:00;;2023-06-24T14:32:44+00:00;9,00 €\n")
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

  describe '/automated_tickets/new' do
    context 'GET' do
      describe 'automated_tickets#new' do
        it 'returns the automated_ticket wizard'
      end
    end
  end

  describe '/automated_tickets/:id' do
    context 'PATCH' do
      describe 'automated_tickets#update' do
        it 'updates the automated_ticket'
      end
    end
    context 'PUT' do
      describe 'automated_tickets#update' do
        it 'updates the automated_ticket'
      end
    end
    context 'DELETE' do
      describe 'automated_tickets#destroy' do
        it 'destroys the automated_ticket'
      end
    end
  end
end
