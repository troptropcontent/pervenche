require 'rails_helper'

RSpec.describe AutomatedTicket, type: :model do
  subject { automated_ticket }
  describe 'validations' do
    context 'uniqueness' do
      let(:user) do
        user = FactoryBot.build(:user)
        user.save(validate: false)
        user
      end
      let(:service) do
        service = FactoryBot.build(:service, user_id: user.id)
        service.save(validate: false)
        service
      end
      let!(:automated_ticket) do
        FactoryBot.build(
          :automated_ticket,
          user_id: user.id,
          service: service
        )
      end
      context 'license_plate' do
        it { should validate_uniqueness_of(:license_plate).scoped_to(%i[user_id service_id]) }
      end
    end
    context 'presence' do
      it 'We should have here all specs related to the conditionnal validation that we have on the model'
    end
  end
end
