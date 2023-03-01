RSpec.shared_context 'a user with a service with an automated ticket' do 
    let(:user) {FactoryBot.create(:user)}
    let(:service) do
        service = FactoryBot.build(:service, user:)
        service.save(validate: false)
        service
    end
    let(:automated_ticket) {FactoryBot.create(:automated_ticket, user:, service:) }
end