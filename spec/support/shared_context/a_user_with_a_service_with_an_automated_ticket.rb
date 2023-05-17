RSpec.shared_context 'a user with a service with an automated ticket' do |last_validated_step|
  let(:user) { FactoryBot.create(:user) }
  let!(:service) do
    service = FactoryBot.build(:service, user:, name: 'a_fake_service_name')
    service.save(validate: false)
    service
  end
  let!(:automated_ticket) do
    automated_ticket = FactoryBot.build(
      :automated_ticket,
      user:,
      kind:,
      service: automated_ticket_service,
      rate_option_client_internal_id:,
      license_plate:,
      payment_method_client_internal_ids:,
      localisation:,
      vehicle_type:,
      vehicle_description:,
      zipcodes:,
      accepted_time_units: automated_ticket_accepted_time_units,
      weekdays: automated_ticket_weekdays,
      free: automated_ticket_free
    )
    automated_ticket.save(validate: false)
    automated_ticket
  end
  let(:rate_option_client_internal_id) {}
  let(:kind) {}
  let(:license_plate) {}
  let(:automated_ticket_service) {}
  let(:payment_method_client_internal_ids) {}
  let(:localisation) {}
  let(:vehicle_type) {}
  let(:vehicle_description) {}
  let(:automated_ticket_accepted_time_units) {}
  let(:zipcodes) {}
  let(:automated_ticket_weekdays) {}
  let(:automated_ticket_free) {}

  case last_validated_step
  when :service
    let(:automated_ticket_service) { service }
  when :kind
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
  when :localisation
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
    let(:localisation) { 'paris' }
  when :vehicle
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
    let(:localisation) { 'paris' }
    let(:license_plate) { 'CL123UU' }
    let(:vehicle_type) { 'electric_motorcycle' }
    let(:vehicle_description) { 'a_fake_name' }
  when :zipcodes
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
    let(:localisation) { 'paris' }
    let(:license_plate) { 'CL123UU' }
    let(:vehicle_type) { 'electric_motorcycle' }
    let(:vehicle_description) { 'a_fake_name' }
    let(:zipcodes) { %w[75008 75017 75019] }
  when :rate_option
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
    let(:localisation) { 'paris' }
    let(:license_plate) { 'CL123UU' }
    let(:vehicle_type) { 'electric_motorcycle' }
    let(:vehicle_description) { 'a_fake_name' }
    let(:zipcodes) { %w[75008 75017 75019] }
    let(:rate_option_client_internal_id) { 'a_fake_rate_option_id' }
    let(:automated_ticket_accepted_time_units) { ['days'] }
    let(:automated_ticket_free) { false }
  when :weekdays
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
    let(:localisation) { 'paris' }
    let(:license_plate) { 'CL123UU' }
    let(:vehicle_type) { 'electric_motorcycle' }
    let(:vehicle_description) { 'a_fake_name' }
    let(:zipcodes) { %w[75008 75017 75019] }
    let(:rate_option_client_internal_id) { 'a_fake_rate_option_id' }
    let(:automated_ticket_accepted_time_units) { ['days'] }
    let(:automated_ticket_weekdays) { [1] }
    let(:automated_ticket_free) { false }
  when :payment_methods
    let(:automated_ticket_service) { service }
    let(:kind) { 'electric_motorcycle' }
    let(:localisation) { 'paris' }
    let(:license_plate) { 'CL123UU' }
    let(:vehicle_type) { 'electric_motorcycle' }
    let(:vehicle_description) { 'a_fake_name' }
    let(:zipcodes) { %w[75008 75017 75019] }
    let(:rate_option_client_internal_id) { 'a_fake_rate_option_id' }
    let(:automated_ticket_accepted_time_units) { ['days'] }
    let(:automated_ticket_weekdays) { [1] }
    let(:payment_method_client_internal_ids) { ['AFakePaymentMethodId'] }
    let(:automated_ticket_free) { false }
  end
end
