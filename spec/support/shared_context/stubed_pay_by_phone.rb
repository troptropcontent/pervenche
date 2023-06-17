# frozen_string_literal: true

RSpec.shared_context 'stubed PayByPhone' do |username, password|
  before do
    stubed_rate_options = [
      ParkingTicket::Clients::Models::RateOption.new(
        client_internal_id: '1085252721', name: 'shared rate option', type: 'RES',
        accepted_time_units: %w[minutes hours], free: true
      ),
      ParkingTicket::Clients::Models::RateOption.new(
        client_internal_id: '1085252721', name: 'shared rate option', type: 'VP-2RM',
        accepted_time_units: %w[minutes hours], free: true
      ),
      ParkingTicket::Clients::Models::RateOption.new(
        client_internal_id: '1085252721', name: 'shared rate option', type: 'CMI',
        accepted_time_units: %w[minutes hours], free: true
      )
    ]

    stubed_quote = ParkingTicket::Clients::Models::Quote.new(
      client_internal_id: '13a3556a-afeb-46a3-b82f-e94bab23c1c0',
      starts_on: DateTime.parse('2023-04-05T06:15:56Z'),
      ends_on: DateTime.parse('2023-04-05T18:00:00Z'),
      cost: 1.5
    )
    pay_by_phone_adapter_double = instance_double(ParkingTicket::Clients::PayByPhone::Adapter,
                                                  rate_options: stubed_rate_options, quote: stubed_quote)
    allow(ParkingTicket::Clients::PayByPhone::Adapter).to receive(:new).with(username,
                                                                             password).and_return(pay_by_phone_adapter_double)
  end
end

RSpec.shared_context 'stubed pay_by_phone auth' do |username = 'username', password = 'password', token = 'a_token'|
  let(:stubed_token) { 'a_token' }
  let(:stubed_auth_endpoint_body) do
  end
  before do
    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:auth)
        .with(username, password)
          .and_return({ 'access_token' => token })
    )
  end
end

RSpec.shared_context 'stubed pay_by_phone failed auth' do |username = 'username', password = 'password', _token = 'a_token'|
  let(:stubed_token) { 'a_token' }
  let(:stubed_auth_endpoint_body) do
  end
  before do
    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:auth)
        .with(username, password)
          .and_return({})
    )
  end
end

RSpec.shared_context 'stubed pay_by_phone account_id' do |token = 'a_token', account_id = 'a_account_id'|
  before do
    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:account_id)
        .with(token)
          .and_return(account_id)
    )
  end
end

RSpec.shared_context 'stubed pay_by_phone rate_options' do |zipcode, license_plate, rate_options_count = 1, options = {}|
  before do
    token = options[:token] || 'a_token'
    account_id = options[:account_id] || 'a_account_id'
    possible_rate_options = [
      {
        'acceptedTimeUnits' => ['Days'],
        'name' => 'stubed_name',
        'type' => 'RES',
        'rateOptionId' => 'a_res_rate_option_id'
      },
      {
        'acceptedTimeUnits' => ['Days'],
        'name' => 'stubed_name',
        'type' => 'CUSTOM',
        'rateOptionId' => 'a_custom_rate_option_id'
      }
    ]

    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:rate_options)
        .with(token, account_id, zipcode, license_plate)
          .and_return(possible_rate_options[0...rate_options_count])
    )
  end
end

RSpec.shared_context 'stubed pay_by_phone quote' do |zipcode, license_plate, options = {}|
  before do
    cost = options[:cost] || 1.5
    rate_option_id = options[:rate_option_id] || 'a_res_rate_option_id'
    quantity = options[:quantity] || 1
    time_unit = options[:time_unit] || 'Days'
    token = options[:token] || 'a_token'
    account_id = options[:account_id] || 'a_account_id'
    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:quote)
        .with(token, account_id, rate_option_id, zipcode, license_plate, quantity, time_unit)
          .and_return({
                        'quoteId' => 'a_quote_id',
                        'parkingStartTime' => '2023-04-03T17:11:12+00:00',
                        'parkingExpiryTime' => '2023-04-03T17:20:00+00:00',
                        'cost' => cost
                      })
    )
  end
end

RSpec.shared_context 'stubed pay_by_phone vehicles' do |token = 'a_token', vehicles = [
  { license_plate: 'AA123BB', vehicle_type: 'ElectricMotorcycle' }, { license_plate: 'AA123BB', vehicle_type: 'Car' }
]|
  before do
    stubed_vehicles = vehicles.map.with_index do |vehicle, index|
      {
        'vehicleId' => (index + 1).to_s * 10,
        'licensePlate' => vehicle[:license_plate],
        'type' => vehicle[:vehicle_type],
        'profile' => { 'description' => vehicle[:vehicle_description] }

      }
    end
    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:vehicles)
        .with(token)
          .and_return(stubed_vehicles)
    )
  end
end

RSpec.shared_context 'stubed pay_by_phone payment_methods' do |token = 'a_token', payment_methods_count = 0|
  before do
    stubed_payment_methods = []

    payment_methods_count.times do |i|
      stubed_payment_methods << {
        'paymentAccountId' => i.to_s * 10,
        'maskedCardNumber' => i.to_s * 10,
        'cardType' => 'MasterCard'
      }
    end

    allow(ParkingTicket::Clients::PayByPhone::Client).to(
      receive(:payment_methods)
        .with(token)
          .and_return({ 'paymentCards' => stubed_payment_methods })
    )
  end
end
