RSpec.shared_context 'a stubed service' do 
  let(:service_vehicles_stub) do
    [
      {
        client_internal_id: 'a_fake_client_id',
        license_plate: 'a_fake_license_plate',
        vehicle_type: 'electric_motorcycle',
        vehicle_description: 'a_fake_name'
      }
    ]
  end
  let(:service_rate_options_75008_stub) do
    [
      { client_internal_id: '75008', name: 'Résident', type: 'RES', accepted_time_units: ['days'],
        free: false },
      { client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
        accepted_time_units: %w[minutes hours], free: true }
    ]
  end
  let(:service_rate_options_75017_stub) do
    [
      { client_internal_id: '75017', name: 'Résident', type: 'RES', accepted_time_units: ['days'],
        free: false },
      { client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
        accepted_time_units: %w[minutes hours], free: true }
    ]
  end
  let(:service_rate_options_75019_stub) do
    [
      { client_internal_id: '75019', name: 'Résident', type: 'RES', accepted_time_units: ['days'],
        free: false },
      { client_internal_id: '1085252721', name: 'shared rate option', type: 'CUSTOM',
        accepted_time_units: %w[minutes hours], free: true }
    ]
  end
  let(:service_payment_methods_stub) do
    [
     { client_internal_id: 'fake-payment-methof-id-9654e1084eb1', anonymised_card_number: '6156',
       payment_card_type: 'visa' }
      ]
  end
  before do
    allow(automated_ticket).to receive(:service).and_return(service)
    allow(service).to receive(:vehicles).and_return(service_vehicles_stub)
    allow(service).to receive(:rate_options).with("75008", any_args).and_return(service_rate_options_75008_stub)
    allow(service).to receive(:rate_options).with("75017", any_args).and_return(service_rate_options_75017_stub)
    allow(service).to receive(:rate_options).with("75019", any_args).and_return(service_rate_options_75019_stub)
    allow(service).to receive(:payment_methods).and_return(service_payment_methods_stub)
  end
end
