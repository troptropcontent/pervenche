require 'rails_helper'
RSpec.describe MenuLinksGenerator do
  subject { described_class.call(user) }
  let(:user) { FactoryBot.create(:user) }
  context 'when the user does not have a service' do
    it 'does not return the edit service link' do
      expect(subject.map(&:text)).not_to include('Compte PayByPhone')
    end
  end
  context 'when have a service' do
    let!(:service) { FactoryBot.create(:service, :without_validations, user:) }
    it 'returns the edit service link' do
      expect(subject.map(&:text)).to include('Compte PayByPhone')
    end
  end
end
