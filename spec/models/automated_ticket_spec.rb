require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'
RSpec.describe AutomatedTicket, type: :model do
  subject { FactoryBot.build(:automated_ticket, :set_up, user:, service:, zipcodes:) }
  let(:zipcodes) { %w[75018 75017 75016] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end

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
          let(:zipcodes) { [] }
          it do
            expect(subject).to be_invalid
            expect(subject.errors.full_messages).to include('Zipcodes doit contenir au moins un élément')
          end
        end
        context 'non empty array' do
          it do
            expect(subject).to be_valid
          end
        end
      end
      describe 'weekdays' do
        context 'free ticket' do
          before do
            subject.weekdays = []
            subject.free = true
          end
          it 'does not require weekdays if the ticket is free' do
            expect(subject).to be_invalid
          end
        end
        context 'not free ticket' do
          context 'empty array' do
            before do
              subject.weekdays = []
            end
            it 'require at list one weekdays if the ticket is not free' do
              expect(subject).to be_invalid
              expect(subject.errors.full_messages).to include('Weekdays doit contenir au moins un élément')
            end
          end
        end
      end
      describe 'payment_method_client_internal_ids' do
        context 'free ticket' do
          before do
            subject.payment_method_client_internal_ids = []
            subject.free = true
          end
          it 'does not require weekdays if the ticket is free' do
            expect(subject).to be_valid
          end
        end
        context 'not free ticket' do
          context 'empty array' do
            before do
              subject.payment_method_client_internal_ids = []
            end
            it 'require at list one weekdays if the ticket is not free' do
              expect(subject).to be_invalid
              expect(subject.errors.full_messages).to include('Payment method client internal ids doit contenir au moins un élément')
            end
          end
        end
      end
    end

    context 'ticket_already_registered' do
      context 'when a ticket already exists with the similar characteristics' do
        let!(:an_already_existing_automated_ticket) do
          FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes: already_covered_zipcodes)
        end
        let!(:already_covered_zipcodes) { ['75018'] }
        it 'is not valid' do
          expect(subject).to be_invalid
          expect(subject.errors.messages.values.flatten).to include("Un ticket est déja parametré pour ce tarif, cette plaque d'immatriclation et ce code postal")
        end

        context 'when a similar ticket exists for several zipcodes' do
          let!(:already_covered_zipcodes) { %w[75018 75017] }
          it 'is not valid' do
            expect(subject).to be_invalid
            expect(subject.errors.messages.values.flatten).to include("Des tickets sont déja paramétrés pour ce tarif, cette plaque d'immatriculation pour ces code postaux 75018, 75017")
          end
        end
      end
    end
  end

  describe '#instance_methods' do
    context '#should_renew_today?' do
      context "when today's weekday is included in automated_ticket.weekdays" do
        before do
          subject.weekdays = [Date.today.wday]
        end
        it 'should return true' do
          expect(subject.should_renew_today?).to eq(true)
        end
      end
      context "when today's weekday is not included in automated_ticket.weekdays" do
        before do
          subject.weekdays = [Date.today.tomorrow.wday]
        end
        it 'should return true' do
          expect(subject.should_renew_today?).to eq(false)
        end
      end
    end
  end
end
