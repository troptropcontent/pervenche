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
      before do
        allow(service).to receive(:valid_credentials).and_return(true)
      end
      context 'uniqueness on kind' do
        let!(:an_already_existing_service) do
          service = FactoryBot.build(:service, username:, password:, kind:, user:)
          service.save(validate: false)
          service
        end
        let(:kind) { 'pay_by_phone' }
        let(:username) { '+33612345678' }
        let(:password) { 'password' }
        let!(:service) { FactoryBot.build(:service, username:, password:, kind:, user:) }
        it 'works' do
          expect(subject).to be_invalid
          expect(subject.errors[:username]).to include('Ce compte est déja enregistré sur la plateforme')
        end
      end
      context 'phone' do
        let(:kind) { 'pay_by_phone' }
        let(:password) { 'password' }
        context 'when the username is not a valid phone' do
          let(:username) { 'tom@example.com' }
          it 'returns an error' do
            expect(subject).to be_invalid
            expect(subject.errors[:username]).to include("n'est pas valide")
          end
        end
        context 'when the username is a valid phone' do
          let(:username) { '+33612345678' }
          it 'is valid' do
            expect(subject).to be_valid
          end
        end
      end
    end
  end
end
