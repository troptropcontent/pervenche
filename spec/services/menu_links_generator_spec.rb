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
    let(:expected_links) do
      ['Me déconnecter', 'Compte PayByPhone', 'Facturation et moyen de paiement']
    end
    it 'returns the edit service link' do
      expect(subject.map(&:text)).to eq(expected_links)
    end
  end
  context 'when the user is admin' do
    let(:user) { FactoryBot.create(:user, roles: ['admin']) }
    let(:expected_links) do
      ['Me déconnecter', 'Abonnements', 'Dashboard']
    end
    it 'returns the dashboard and sbscriptions links' do
      expect(subject.map(&:text)).to eq(expected_links)
    end
  end
end
