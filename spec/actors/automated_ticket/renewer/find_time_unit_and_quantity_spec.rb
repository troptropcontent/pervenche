# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Renewer::FindTimeUnitAndQuantity, type: :actor do
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
    context 'when automated_ticket.accepted_time_units includes days' do
      it 'assigns actor.time_unit to days and actor.quantity to 1' do
        expect(subject.time_unit).to eq('days')
        expect(subject.quantity).to eq(1)
      end
    end
    context 'when automated_ticket.accepted_time_units does not include days' do
      let(:accepted_time_units) { ['hours'] }
      it 'assigns actor.time_unit to hours and actor.quantity to 1' do
        expect(subject.time_unit).to eq('hours')
        expect(subject.quantity).to eq(1)
      end
    end
  end
end
