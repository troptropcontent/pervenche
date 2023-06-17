require 'rails_helper'
RSpec.describe MenuLinksGenerator do
  subject { described_class.call(user) }
  let(:user) { FactoryBot.create(:user) }
  context 'when the user is not operationnal' do
    it 'does not return the edit service link' do
      expect(subject.map(&:text)).not_to include('Compte PayByPhone')
    end
  end
  context 'when the user is operationnal' do
    let(:service) { FactoryBot.create(:service, :without_validations, user:) }
    let!(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, user:, service:) }
    it 'returns the edit service link' do
      expect(subject.map(&:text)).to include('Compte PayByPhone')
    end
  end
end
