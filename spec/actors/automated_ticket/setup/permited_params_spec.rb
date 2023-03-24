# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Setup::PermitedParams, type: :actor do
  subject { described_class.call(params:, step:).permited_params }
  describe '.call' do
    let(:params) do
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
          free:
        }
      )
    end
    let(:service_id) { 'a_service_id' }
    let(:localisation) { 'a_localisation' }
    let(:license_plate) { 'a_license_plate' }
    let(:vehicle_description) { 'a_vehicle_description' }
    let(:vehicle_type) { 'a_vehicle_type' }
    let(:zipcodes) { %w[75001 75002 75018] }
    let(:rate_option_client_internal_id) { 'a_rate_option' }
    let(:accepted_time_units) { %w[days hours] }
    let(:free) { true }
    let(:weekdays) { [1, 2] }
    let(:payment_method_client_internal_ids) { %w[some_payment_method_id another_payment_method_id] }

    context 'service' do
      let(:step) { :service }
      let(:expected_permited_params) do
        params.permit(
          :service_id
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'localisation' do
      let(:step) { :localisation }
      let(:expected_permited_params) do
        params.permit(
          :localisation
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'vehicle' do
      let(:step) { :vehicle }
      let(:expected_permited_params) do
        params.permit(
          :license_plate,
          :vehicle_description,
          :vehicle_type
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'zipcodes' do
      let(:step) { :zipcodes }
      let(:expected_permited_params) do
        params.permit(
          zipcodes: []
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'rate_option' do
      let(:step) { :rate_option }
      let(:expected_permited_params) do
        params.permit(
          :rate_option_client_internal_id,
          :free,
          accepted_time_units: []
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'weekdays' do
      let(:step) { :weekdays }
      let(:expected_permited_params) do
        params.permit(
          weekdays: []
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
    context 'payment_methods' do
      let(:step) { :payment_methods }
      let(:expected_permited_params) do
        params.permit(
          payment_method_client_internal_ids: []
        )
      end
      it 'permit only the relevant params' do
        expect(subject).to eq(expected_permited_params)
      end
    end
  end
end
