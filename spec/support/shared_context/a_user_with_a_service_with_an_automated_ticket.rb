RSpec.shared_context 'a user with a service with an automated ticket' do 
    let(:user) {FactoryBot.create(:user)}
    let(:service) do
        service = FactoryBot.build(:service, user:)
        service.save(validate: false)
        service
    end
    let(:automated_ticket) {FactoryBot.create(
        :automated_ticket, 
        user:, 
        service:, 
        payment_method_client_internal_ids: [automated_ticket_payment_method_client_internal_id],
        payment_method_client_internal_id: automated_ticket_payment_method_client_internal_id,
        localisation: 'paris',
        vehicle_type: "electric_motorcycle",
        zipcodes: ["75008", "75017", "75019"],
        accepted_time_units: automated_ticket_accepted_time_units, 
        weekdays: automated_ticket_weekdays
    ) 
    }
    let(:automated_ticket_payment_method_client_internal_id) {'AFakePaymentMethodId'}
    let(:automated_ticket_accepted_time_units){['days']}
    let(:automated_ticket_weekdays) {[1]}
end