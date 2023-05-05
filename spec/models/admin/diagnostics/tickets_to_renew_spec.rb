# frozen_string_literal: true

require 'rails_helper'

module Admin::Diagnostics
  RSpec.describe TicketsToRenew, type: :model do
    subject { described_class.new }
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
    describe '#instance_methods' do
      describe 'checkup' do
        context 'when some tickets are taken' do
          let(:expected) do
            {
              total_number_of_taken_ticket: 0,
              total_number_of_tickets_to_take: 3,
              total: 3
            }
          end
          it 'returns the correct object' do
            expect(subject.checkup).to eq(expected)
          end
        end
        context 'when no tickets is taken' do
          let!(:running_ticket_in_database_75018) do
            FactoryBot.create(:ticket,
                              ends_on: Date.current.tomorrow,
                              automated_ticket_id: automated_ticket.id,
                              zipcode: '75018')
          end
          let!(:running_ticket_in_database_75017) do
            FactoryBot.create(:ticket,
                              ends_on: Date.current.tomorrow,
                              automated_ticket_id: automated_ticket.id,
                              zipcode: '75017')
          end
          let(:expected) do
            {
              total_number_of_taken_ticket: 2,
              total_number_of_tickets_to_take: 1,
              total: 3
            }
          end
          it 'returns the correct object' do
            expect(subject.checkup).to eq(expected)
          end
        end
        context 'when all tickets are taken' do
          let!(:running_ticket_in_database_75018) do
            FactoryBot.create(:ticket,
                              ends_on: Date.current.tomorrow,
                              automated_ticket_id: automated_ticket.id,
                              zipcode: '75018')
          end
          let!(:running_ticket_in_database_75017) do
            FactoryBot.create(:ticket,
                              ends_on: Date.current.tomorrow,
                              automated_ticket_id: automated_ticket.id,
                              zipcode: '75017')
          end
          let!(:running_ticket_in_database_75016) do
            FactoryBot.create(:ticket,
                              ends_on: Date.current.tomorrow,
                              automated_ticket_id: automated_ticket.id,
                              zipcode: '75016')
          end
          let(:expected) do
            {
              total_number_of_taken_ticket: 3,
              total_number_of_tickets_to_take: 0,
              total: 3
            }
          end
          it 'returns the correct object' do
            expect(subject.checkup).to eq(expected)
          end
        end
      end
    end
  end
end
