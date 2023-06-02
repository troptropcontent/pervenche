# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTickets::AutoCompletable do
  include AutomatedTickets::AutoCompletable
  describe '#autocompletable_attributes(name, automated_ticket)' do
    let!(:automated_ticket) do
      FactoryBot.build(:automated_ticket, :with_zipcodes, user:, service:, zipcodes: ['75019'],
                                                          license_plate: 'license_plate')
    end
    let(:user) { FactoryBot.create(:user) }
    let(:service) do
      service = FactoryBot.build(:service, user_id: user.id, username: 'username', password: 'password')
      service.save(validate: false)
      service
    end
    describe 'service step' do
      context 'when there is only one service related to the user' do
        it 'returns the auto_completable attributes if any' do
          expect(auto_completable_attributes(:service, automated_ticket)).to eq({
                                                                                  service_id: service.id
                                                                                })
        end
      end
      context 'when there is several services related to the user' do
        let!(:another_service) do
          service = FactoryBot.build(:service, user_id: user.id, username: '+33612345699')
          service.save(validate: false)
          service
        end
        it 'returns an empty hash' do
          expect(auto_completable_attributes(:service, automated_ticket)).to eq({})
        end
      end
    end

    describe 'localisation step' do
      it 'returns an empty hash' do
        expect(auto_completable_attributes(:localisation, automated_ticket)).to eq({})
      end
    end

    describe 'kind step' do
      it 'returns an empty hash' do
        expect(auto_completable_attributes(:kind, automated_ticket)).to eq({})
      end
    end

    describe 'vehicle step' do
      it 'returns an empty hash' do
        expect(auto_completable_attributes(:vehicle, automated_ticket)).to eq({})
      end
    end

    describe 'zipcodes step' do
      context "when the automated_ticket have automated_ticket.kind == 'mobility_inclusion_card' && automated_ticket.localisation == 'paris'" do
        let!(:automated_ticket) do
          FactoryBot.build(:automated_ticket, :with_localisation, user:, service:, localisation: 'paris',
                                                                  kind: :mobility_inclusion_card)
        end
        it 'returns the parisian CMI zipcode' do
          expect(auto_completable_attributes(:zipcodes, automated_ticket)).to eq({
                                                                                   zipcodes: ['75100']
                                                                                 })
        end
      end
      context "when the automated_ticket does not have automated_ticket.kind == 'mobility_inclusion_card' && automated_ticket.localisation == 'paris'" do
        it 'returns an empty hash' do
          expect(auto_completable_attributes(:zipcodes, automated_ticket)).to eq({})
        end
      end
    end

    describe 'rate_option step' do
      context 'when there is only one possible rate_option' do
        before do
          allow(service).to receive(:rate_options).and_return([
                                                                ParkingTicket::Clients::Models::RateOption.new(
                                                                  accepted_time_units: ['days'],
                                                                  client_internal_id: 'a_rate_option_id',
                                                                  free: true, name: 'stubed_name',
                                                                  type: 'RES'
                                                                )
                                                              ])
        end

        it 'description' do
          expect(auto_completable_attributes(:rate_option, automated_ticket)).to eq({
                                                                                      rate_option_client_internal_id: 'a_rate_option_id',
                                                                                      accepted_time_units: ['days'],
                                                                                      free: true
                                                                                    })
        end
      end

      context 'when there is several possible rate_options' do
        before do
          allow(service).to receive(:rate_options).and_return([
                                                                ParkingTicket::Clients::Models::RateOption.new(
                                                                  accepted_time_units: ['days'],
                                                                  client_internal_id: 'a_rate_option_id',
                                                                  free: true, name: 'stubed_name',
                                                                  type: 'RES'
                                                                ),
                                                                ParkingTicket::Clients::Models::RateOption.new(
                                                                  accepted_time_units: ['days'],
                                                                  client_internal_id: 'a_other_rate_option_id',
                                                                  free: true,
                                                                  name: 'other stubed_name',
                                                                  type: 'CUSTOM'
                                                                )
                                                              ])
        end
        it 'returns an empty hash' do
          expect(auto_completable_attributes(:rate_option, automated_ticket)).to eq({})
        end
      end
    end

    describe 'weekdays step' do
      it 'always return everyday for now' do
        expect(auto_completable_attributes(:weekdays, automated_ticket)).to eq({ weekdays: [0, 1, 2, 3, 4, 5, 6] })
      end
    end

    describe 'payment_methods step' do
      context 'when there is only one possible payment_method' do
        before do
          allow(service).to receive(:payment_methods).and_return([
                                                                   ParkingTicket::Clients::Models::PaymentMethod.new(
                                                                     anonymised_card_number: '2021',
                                                                     client_internal_id: 'a_payment_method_id',
                                                                     payment_card_type: 'master_card'
                                                                   )
                                                                 ])
        end

        it 'description' do
          expect(auto_completable_attributes(:payment_methods,
                                             automated_ticket)).to eq({ payment_method_client_internal_ids: ['a_payment_method_id'] })
        end
      end

      context 'when there is several possible payment_methods' do
        before do
          allow(service).to receive(:payment_methods).and_return([
                                                                   ParkingTicket::Clients::Models::PaymentMethod.new(
                                                                     anonymised_card_number: '2021',
                                                                     client_internal_id: 'a_payment_method_id',
                                                                     payment_card_type: 'master_card'
                                                                   ),
                                                                   ParkingTicket::Clients::Models::PaymentMethod.new(
                                                                     anonymised_card_number: '2022',
                                                                     client_internal_id: 'a_other_payment_method_id',
                                                                     payment_card_type: 'master_card'
                                                                   )
                                                                 ])
        end
        it 'returns an empty hash' do
          expect(auto_completable_attributes(:payment_methods, automated_ticket)).to eq({})
        end
      end
    end

    describe 'subscription step' do
      it 'returns the auto_completable attributes if any' do
        expect(auto_completable_attributes(:subscription, automated_ticket)).to eq({})
      end
    end
  end
end
