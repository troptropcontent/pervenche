require 'rails_helper'

RSpec.describe Service, type: :model do
  subject { service }
  let(:service) do
    service = FactoryBot.build(:service, username:, password:, kind:, user:)
    service.save(validate: false)
    service
  end
  let!(:user) { FactoryBot.create(:user) }
  let(:username) { nil }
  let(:password) { nil }
  let(:kind) { nil }
  describe 'validations' do
    describe 'username' do
      context 'uniqueness on kind' do
        before do
          allow(service).to receive(:valid_credentials).and_return(true)
        end

        let!(:an_already_existing_service) do
          service = FactoryBot.build(:service, username:, password:, kind:, user:)
          service.save(validate: false)
          service
        end
        let(:kind) { 'pay_by_phone' }
        let(:username) { 'username' }
        let(:password) { 'password' }
        let!(:service) { FactoryBot.build(:service, username:, password:, kind:, user:) }
        it 'works' do
          expect(subject).to be_invalid
          expect(subject.errors.messages.values).to include(['Ce compte est déja enregistré sur la plateforme'])
        end
      end
    end
  end
end
