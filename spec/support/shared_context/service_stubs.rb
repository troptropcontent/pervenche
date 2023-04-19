# frozen_string_literal: true

RSpec.shared_context 'a stubed service' do
  let(:service_vehicles_stub) do
    [
      ParkingTicket::Clients::Models::Vehicle.new(
        client_internal_id: 'a_fake_client_id',
        license_plate: 'CL123UU',
        vehicle_type: 'electric_motorcycle',
        vehicle_description: 'a_fake_name'
      )
    ]
  end
  let(:service_rate_options_stub) do
    [
      ParkingTicket::Clients::Models::RateOption.new(
        client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
        accepted_time_units: %w[minutes hours], free: true
      )
    ]
  end
  let(:service_payment_methods_stub) do
    [
      ParkingTicket::Clients::Models::PaymentMethod.new(
        client_internal_id: 'fake-payment-methof-id-9654e1084eb1', anonymised_card_number: '6156',
        payment_card_type: 'visa'
      )
    ]
  end
  before do
    allow(automated_ticket).to receive(:service).and_return(service)
    allow(service).to receive(:vehicles).and_return(service_vehicles_stub)
    allow(service).to receive(:rate_options).with(%w[75008 75017 75019],
                                                  any_args).and_return(service_rate_options_stub)
    allow(service).to receive(:payment_methods).and_return(service_payment_methods_stub)
  end
end
