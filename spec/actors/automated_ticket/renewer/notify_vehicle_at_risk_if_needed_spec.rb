# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTicket::Renewer::NotifyVehicleAtRiskIfNeeded,
               type: :actor do
  include ActiveSupport::Testing::TimeHelpers
  Sidekiq::Testing.fake!
  subject do
    described_class.call(automated_ticket:,
                         zipcode:)
  end
  let(:automated_ticket) do
    FactoryBot.create(:automated_ticket,
                      :set_up,
                      user:,
                      service:, zipcodes: ['75018'],
                      last_activated_at:)
  end
  let(:last_activated_at) { 8.minutes.ago }
  let(:user) { FactoryBot.create(:user) }
  let(:service) { FactoryBot.create(:service, :without_validations, username: '+33678901234', password: 'password') }

  describe '.call' do
    subject { described_class.call(automated_ticket:, zipcode: '75018') }
    context 'when there is no ticket in the database' do
      context 'when the automated ticket have been active for more than 5 minutes' do
        context 'when the user have already been notified' do
          before do
            Notification.create(
              recipient: user,
              type: 'VehicleAtRiskNotification',
              params: {
                user_email: user.email,
                license_plate: automated_ticket.license_plate,
                zipcode: automated_ticket.zipcodes.first,
                uncovered_since: automated_ticket.last_activated_at,
                automated_ticket_id: automated_ticket.id
              }
            )
          end
          it 'should not notify the user' do
            expect(VehicleAtRiskNotification).not_to receive(:with)
            subject
          end
        end
        context 'when the user have not already been notified' do
          let(:expected_enqued_job_params_argument) do
            {
              'user_email' => user.email,
              'license_plate' => automated_ticket.license_plate,
              'zipcode' => '75018',
              'uncovered_since' => {
                '_aj_serialized' => 'ActiveJob::Serializers::TimeWithZoneSerializer',
                'value' => automated_ticket.last_activated_at.iso8601(9)
              },
              'automated_ticket_id' => automated_ticket.id,
              '_aj_symbol_keys' => %w[user_email license_plate zipcode uncovered_since automated_ticket_id]
            }
          end
          it 'should notify the user' do
            expect { subject }.to change(Sidekiq::Queues['critical'], :size).from(0).to(1)
            enqueded_job = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'job_class')
            enqueded_job_notification_class_argument = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'arguments', 0, 'notification_class')
            enqueded_job_params_argument = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'arguments', 0, 'params')
            expect(enqueded_job).to eq('DeliveryMethods::Discord')
            expect(enqueded_job_notification_class_argument).to eq('Admin::VehicleAtRiskNotification')
            expect(enqueded_job_params_argument).to match(expected_enqued_job_params_argument)
          end
        end
      end
      context 'when the automated ticket have been active for less than 5 minutes' do
        let(:last_activated_at) { 4.minutes.ago }
        it 'should not notify the user' do
          expect(VehicleAtRiskNotification).not_to receive(:with)
          subject
        end
      end
    end
    context 'when there is some tickets in the database' do
      let!(:ticket) do
        FactoryBot.create(:ticket,
                          ends_on: minutes_ago.minutes.ago,
                          automated_ticket_id: automated_ticket.id,
                          zipcode: '75018')
      end
      let(:minutes_ago) { 2 }
      context 'when the last ticket has ended more than 5 minutes ago' do
        let(:minutes_ago) { 6 }

        context 'when the user have not been notified already' do
          let(:expected_enqued_job_params_argument) do
            {
              'user_email' => user.email,
              'license_plate' => automated_ticket.license_plate,
              'zipcode' => '75018',
              'uncovered_since' => {
                '_aj_serialized' => 'ActiveJob::Serializers::TimeWithZoneSerializer',
                'value' => ticket.ends_on.iso8601(9)
              },
              'automated_ticket_id' => automated_ticket.id,
              '_aj_symbol_keys' => %w[user_email license_plate zipcode uncovered_since automated_ticket_id]
            }
          end
          it 'should notify the user' do
            expect { subject }.to change(Sidekiq::Queues['critical'], :size).from(0).to(1)
            enqueded_job = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'job_class')
            enqueded_job_notification_class_argument = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'arguments', 0, 'notification_class')
            enqueded_job_params_argument = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'arguments', 0, 'params')
            expect(enqueded_job).to eq('DeliveryMethods::Discord')
            expect(enqueded_job_notification_class_argument).to eq('Admin::VehicleAtRiskNotification')
            expect(enqueded_job_params_argument).to match(expected_enqued_job_params_argument)
          end

          context 'when we are not during paying hours' do
            it 'should not notify the user' do
              travel_to(ActiveSupport::TimeZone['Paris'].parse('20:01:00')) do
                expect(VehicleAtRiskNotification).not_to receive(:with)
                subject
              end
            end
          end
        end

        context 'when the user have been notified already' do
          before do
            Notification.create(
              recipient: user,
              type: 'VehicleAtRiskNotification',
              params: {
                user_email: user.email,
                license_plate: automated_ticket.license_plate,
                zipcode: automated_ticket.zipcodes.first,
                uncovered_since: ticket.ends_on,
                automated_ticket_id: automated_ticket.id
              }
            )
          end
          it 'should not notify the user' do
            expect(VehicleAtRiskNotification).not_to receive(:with)
            subject
          end
        end

        context 'when the last ticket ends_on is before the last_activated_at' do
          context 'when the last_activated_at is less than 5 minutes ago' do
            let(:last_activated_at) { 4.minutes.ago }
            it 'should not notify the user' do
              expect(VehicleAtRiskNotification).not_to receive(:with)
              subject
            end
          end
          context 'when the last_activated_at is more than 5 minutes ago' do
            let(:last_activated_at) { 6.minutes.ago }
            context 'when the user have not been notified already' do
              let(:expected_enqued_job_params_argument) do
                {
                  'user_email' => user.email,
                  'license_plate' => automated_ticket.license_plate,
                  'zipcode' => '75018',
                  'uncovered_since' => {
                    '_aj_serialized' => 'ActiveJob::Serializers::TimeWithZoneSerializer',
                    'value' => automated_ticket.last_activated_at.iso8601(9)
                  },
                  'automated_ticket_id' => automated_ticket.id,
                  '_aj_symbol_keys' => %w[user_email license_plate zipcode uncovered_since automated_ticket_id]
                }
              end
              it 'should notify the user' do
                expect { subject }.to change(Sidekiq::Queues['critical'], :size).from(0).to(1)
                enqueded_job = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'job_class')
                enqueded_job_notification_class_argument = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'arguments', 0, 'notification_class')
                enqueded_job_params_argument = Sidekiq::Queues['critical'].dig(0, 'args', 0, 'arguments', 0, 'params')
                expect(enqueded_job).to eq('DeliveryMethods::Discord')
                expect(enqueded_job_notification_class_argument).to eq('Admin::VehicleAtRiskNotification')
                expect(enqueded_job_params_argument).to match(expected_enqued_job_params_argument)
              end
            end

            context 'when the user have been notified already' do
              before do
                Notification.create(
                  recipient: user,
                  type: 'VehicleAtRiskNotification',
                  params: {
                    user_email: user.email,
                    license_plate: automated_ticket.license_plate,
                    zipcode: automated_ticket.zipcodes.first,
                    uncovered_since: automated_ticket.last_activated_at,
                    automated_ticket_id: automated_ticket.id
                  }
                )
              end
              it 'should not notify the user' do
                expect(VehicleAtRiskNotification).not_to receive(:with)
                subject
              end
            end
          end
        end
      end

      context 'when the last ticket has ended less than 5 minutes ago' do
        let!(:ticket) do
          FactoryBot.create(:ticket,
                            ends_on: minutes_ago.minutes.ago,
                            automated_ticket_id: automated_ticket.id,
                            zipcode: '75018')
        end
        it 'should not notify the user' do
          expect(VehicleAtRiskNotification).not_to receive(:with)
          subject
        end
      end
      context 'when the last ticket has not ended yet' do
        let!(:ticket) do
          FactoryBot.create(:ticket,
                            ends_on: 3.minutes.from_now,
                            automated_ticket_id: automated_ticket.id,
                            zipcode: '75018')
        end
        it 'should not notify the user' do
          expect(VehicleAtRiskNotification).not_to receive(:with)
          subject
        end
      end
    end
  end
end
