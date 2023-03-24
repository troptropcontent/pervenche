require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
RSpec.describe AutomatedTicket, type: :model do
  include_context 'a user with a service with an automated ticket'
  subject { automated_ticket }

  let(:user) { FactoryBot.create(:user) }

  describe 'validations' do
    context 'presence' do
      it { should validate_presence_of(:service_id) }
      it { should validate_presence_of(:localisation) }
      it { should validate_presence_of(:license_plate) }
      it { should validate_presence_of(:rate_option_client_internal_id) }
    end

    context 'length' do
      describe 'zipcodes' do
        context 'empty array' do
          before do
            automated_ticket.zipcodes = []
          end
          it do
            expect(automated_ticket).to be_invalid
            expect(automated_ticket.errors.full_messages).to include('Zipcodes doit contenir au moins un élément')
          end
        end
        context 'non empty array' do
          it do
            expect(automated_ticket).to be_valid
          end
        end
      end
      describe 'weekdays' do
        context 'free ticket' do
          before do
            automated_ticket.weekdays = []
            automated_ticket.free = true
          end
          it 'does not require weekdays if the ticket is free' do
            expect(automated_ticket).to be_valid
          end
        end
        context 'not free ticket' do
          context 'empty array' do
            before do
              automated_ticket.weekdays = []
            end
            it 'require at list one weekdays if the ticket is not free' do
              expect(automated_ticket).to be_invalid
              expect(automated_ticket.errors.full_messages).to include('Weekdays doit contenir au moins un élément')
            end
          end
        end
      end
      describe 'payment_method_client_internal_ids' do
        context 'free ticket' do
          before do
            automated_ticket.payment_method_client_internal_ids = []
            automated_ticket.free = true
          end
          it 'does not require weekdays if the ticket is free' do
            expect(automated_ticket).to be_valid
          end
        end
        context 'not free ticket' do
          context 'empty array' do
            before do
              automated_ticket.payment_method_client_internal_ids = []
            end
            it 'require at list one weekdays if the ticket is not free' do
              expect(automated_ticket).to be_invalid
              expect(automated_ticket.errors.full_messages).to include('Payment method client internal ids doit contenir au moins un élément')
            end
          end
        end
      end
    end
  end

  describe '#instance_methods' do
    context '#find_or_create_running_ticket_if_it_exists' do
      before do
        allow(subject).to receive(:running_ticket_in_client).and_return(running_ticket_in_client)
      end
      let(:running_ticket_in_client) { nil }
      context 'when a running ticket exists in the database' do
        let!(:running_ticket_in_database) do
          FactoryBot.create(:ticket, automated_ticket: subject, ends_on: 2.minutes.from_now)
        end
        it 'returns the running ticket' do
          expect(subject.find_or_create_running_ticket_if_it_exists).to eq(running_ticket_in_database)
        end
      end
      context 'when a running ticket does not exist in the database' do
        context 'when a ticket exist in the client' do
          let(:running_ticket_in_client) do
            {
              starts_on: '2023-01-25 13:35:58'.to_datetime.in_time_zone,
              ends_on: '2023-01-25 13:35:58'.to_datetime.in_time_zone,
              license_plate: 'MyLicensePlate',
              cost: 1,
              client_internal_id: 'FakeClientInternalId',
              client: 'pay_by_phone'
            }
          end
          it 'creates a new ticket in the database and returns it' do
            ticket_count = Ticket.count
            result = subject.find_or_create_running_ticket_if_it_exists
            expect(**result.attributes).to include(**running_ticket_in_client.except(:client, :cost).stringify_keys)
            expect(result.cost_cents).to eq(100)
            expect(Ticket.count).to eq(ticket_count + 1)
          end
        end
        context 'when a ticket does not exist in the client' do
          it 'return null' do
            expect(subject.find_or_create_running_ticket_if_it_exists).to eq(nil)
          end
        end
      end
    end
    context '#should_renew_today?' do
      let(:weekdays) { [Date.today.wday] }
      context "when today's weekday is included in automated_ticket.weekdays" do
        it 'should return true' do
          expect(subject.should_renew_today?).to eq(true)
        end
      end
      context "when today's weekday is not included in automated_ticket.weekdays" do
        let(:weekdays) { [Date.today.tomorrow.wday] }
        it 'should return true' do
          expect(subject.should_renew_today?).to eq(false)
        end
      end
    end
  end
end
