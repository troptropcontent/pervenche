require 'rails_helper'
RSpec.describe AutomatedTickets::RenewerJob, type: :job do
  subject { described_class.new.perform(automated_ticket.id, '75018') }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes:)
  end
  let(:zipcodes) { %w[75018 75017 75016] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end

  context 'when the ticket has been requested yet' do
    it 'calls the renewer actor with the relevant argments' do
      expect(AutomatedTicket::Renewer).to receive(:call).with(automated_ticket_id: automated_ticket.id, zipcode: '75018',
                                                              last_request_on: DateTime.new)
      subject
    end
  end
  context 'when the ticket has requested already' do
    let!(:ticket_request_sent) do
      FactoryBot.create(:ticket_request, zipcode: '75018', automated_ticket_id: automated_ticket.id,
                                         requested_on: 2.minutes.ago)
    end
    it 'calls the renewer actor with the relevant argments' do
      expect(AutomatedTicket::Renewer).to receive(:call).with(automated_ticket_id: automated_ticket.id, zipcode: '75018',
                                                              last_request_on: ticket_request_sent.requested_on)
      subject
    end
  end
end
