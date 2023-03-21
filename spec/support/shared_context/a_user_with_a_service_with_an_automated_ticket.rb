RSpec.shared_context 'a user with a service with an automated ticket' do 
    let(:user) {FactoryBot.create(:user)}
    let!(:service) do
        service = FactoryBot.build(:service, user:)
        service.save(validate: false)
        service
    end
    let!(:automated_ticket) {
        automated_ticket = FactoryBot.build(
        :automated_ticket, 
        user:, 
        rate_option_client_internal_id: rate_option_client_internal_id,
        license_plate: license_plate,
        service: automated_ticket_service, 
        payment_method_client_internal_ids: payment_method_client_internal_ids,
        payment_method_client_internal_id: automated_ticket_payment_method_client_internal_id,
        localisation: localisation,
        vehicle_type:vehicle_type,
        vehicle_description:vehicle_description,
        zipcodes: zipcodes,
        accepted_time_units: automated_ticket_accepted_time_units, 
        weekdays: automated_ticket_weekdays,
        free: automated_ticket_free, 
    ) 
    automated_ticket.save(validate: false)
    automated_ticket
    }
    let(:rate_option_client_internal_id) {'a_fake_rate_option_id'}
    let(:license_plate) {'a_fake_license_plate'}
    let(:automated_ticket_service) {service}
    let(:automated_ticket_payment_method_client_internal_id) {'AFakePaymentMethodId'}
    let(:payment_method_client_internal_ids) {[automated_ticket_payment_method_client_internal_id]}
    let(:localisation) {'paris'}
    let(:vehicle_type) {"electric_motorcycle"}
    let(:vehicle_description) {'a_fake_name'}
    let(:automated_ticket_accepted_time_units){['days']}
    let(:zipcodes){["75008", "75017", "75019"]}
    let(:automated_ticket_weekdays) {[1]}
    let(:automated_ticket_free){false}
end