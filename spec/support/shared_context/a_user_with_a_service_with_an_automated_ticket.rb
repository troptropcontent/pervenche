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
        payment_method_client_internal_id: automated_ticket_payment_method_client_internal_id,
        accepted_time_units: automated_ticket_accepted_time_units, 
    ) 
    }
    let(:automated_ticket_payment_method_client_internal_id) {'AFakePaymentMethodId'}
    let(:automated_ticket_accepted_time_units){['days']}
end