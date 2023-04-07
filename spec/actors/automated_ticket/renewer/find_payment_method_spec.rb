# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AutomatedTicket::Renewer::FindPaymentMethod, type: :actor do
  subject { described_class.call(automated_ticket:) }
  let(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes:, weekdays:, free:, accepted_time_units:,
                                                  payment_method_client_internal_ids:)
  end
  let(:free) { false }
  let(:payment_method_client_internal_ids) { %w[the_first_payment_id the_second_payment_method_id] }
  let(:accepted_time_units) { ['days'] }
  let(:weekdays) { [Date.today.wday] }
  let(:zipcodes) { %w[75018 75017 75016] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end

  describe '.call' do
    context 'when the automated_ticket is free' do
      let(:free) { true }
      it 'should assigns actor.payment_method_id to nil' do
        expect(subject.payment_method_id).to eq(nil)
      end
    end
    context 'when the automated_ticketis not free' do
      it 'should assigns actor.payment_method_id to the first payment_method_client_internal_id' do
        expect(subject.payment_method_id).to eq('the_first_payment_id')
      end
    end
  end
end
