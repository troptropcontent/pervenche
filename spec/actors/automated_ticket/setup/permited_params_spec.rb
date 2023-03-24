# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Setup::PermitedParams, type: :actor do
  subject { described_class.call(params:, step:).permited_params }
  describe '.call' do

    let(:params) {
      ActionController::Parameters.new(
        {
          service_id:,
          localisation:,
          license_plate:,
          vehicle_description:,
          vehicle_type:,
          zipcodes:,
          rate_option_client_internal_id:,
          accepted_time_units:,
          weekdays:,
          payment_method_client_internal_ids:,
          free:, 
        }
      )
    }
    let(:service_id){'a_service_id'}
    let(:localisation){'a_localisation'}
    let(:license_plate){'a_license_plate'}
    let(:vehicle_description){'a_vehicle_description'}
    let(:vehicle_type){'a_vehicle_type'}
    let(:zipcodes){['75001', '75002', '75018']}
    let(:rate_option_client_internal_id){'a_rate_option'}
    let(:accepted_time_units){['days', 'hours']}
    let(:free){true}
    let(:weekdays){[1,2]}
    let(:payment_method_client_internal_ids){['some_payment_method_id', 'another_payment_method_id']}

    context 'service' do
      let(:step){:service}
      let(:expected_permited_params) {
        params.permit(
          :service_id
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'localisation' do
      let(:step){:localisation}
      let(:expected_permited_params) {
        params.permit(
          :localisation
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'vehicle' do
      let(:step){:vehicle}
      let(:expected_permited_params) {
        params.permit(
          :license_plate,
          :vehicle_description,
          :vehicle_type,
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'zipcodes' do
      let(:step){:zipcodes}
      let(:expected_permited_params) {
        params.permit(
          zipcodes: []
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'rate_option' do
      let(:step){:rate_option}
      let(:expected_permited_params) {
        params.permit(
          :rate_option_client_internal_id,
          :free,
          accepted_time_units: []
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'weekdays' do
      let(:step){:weekdays}
      let(:expected_permited_params) {
        params.permit(
          weekdays: []
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'payment_methods' do
      let(:step){:payment_methods}
      let(:expected_permited_params) {
        params.permit(
          payment_method_client_internal_ids: []
        )
      }
      it "permit only the relevant params" do
        expect(subject).to eq(expected_permited_params)
      end
    end
  end
end



