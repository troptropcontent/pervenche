require 'rails_helper'

RSpec.describe Service, type: :model do
  subject { service }
  let(:service) do
    service = FactoryBot.build(:service)
    service.save(validate: false)
    service
  end
  describe 'validations' do
    pending 'We should have here all the specs for the validations that we have'
  end
end
