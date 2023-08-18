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
                      service:, zipcodes: ['75018'])
  end

  let(:user) { FactoryBot.create(:user) }
  let(:service) { FactoryBot.create(:service, :without_validations, username: '+33678901234', password: 'password') }

  describe '.call' do
    subject { described_class.call(automated_ticket:, zipcode: '75018') }
    context 'when there is no ticket in the database' do
      context 'when the automated ticket have been active for more than 5 minutes' do
        let(:automated_ticket) do
          FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes: ['75018'], last_activated_at: 6.minutes.ago)
        end
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
          let(:expected_enqued_job_arguments) do
            {
              'notification_class' => 'Admin::VehicleAtRiskNotification',
              'options' => {
                'class' => 'DeliveryMethods::Discord',
                'channel' => {
                  '_aj_serialized' => 'ActiveJob::Serializers::SymbolSerializer',
                  'value' => 'vehicle_at_risk'
                },
                '_aj_symbol_keys' => %w[class channel]
              },
              'params' => {
                'user_email' => user.email,
                'license_plate' => automated_ticket.license_plate,
                'zipcode' => '75018',
                'uncovered_since' => {
                  '_aj_serialized' => 'ActiveJob::Serializers::TimeWithZoneSerializer',
                  'value' => '2004-11-23T23:58:44.000000000Z'
                },
                'automated_ticket_id' => automated_ticket.id,
                '_aj_symbol_keys' => %w[user_email license_plate zipcode uncovered_since automated_ticket_id]
              },
              'recipient' => { '_aj_globalid' => "gid://pervenche/User/#{user.id}" },
              'record' => { '_aj_globalid' => an_instance_of(String) },
              '_aj_symbol_keys' => %w[notification_class options params recipient record]
            }
          end
          it 'should notify the user' do
            travel_to Time.new(2004, 11, 24, 0o1, 0o4, 44) do
              expect { subject }.to change(Sidekiq::Queues['default'], :size).from(0).to(1)
              enqueded_job = Sidekiq::Queues['default'].dig(0, 'args', 0, 'job_class')
              enqueded_job_arguments = Sidekiq::Queues['default'].dig(0, 'args', 0, 'arguments', 0)
              expect(enqueded_job).to eq('DeliveryMethods::Discord')
              expect(enqueded_job_arguments).to match(expected_enqued_job_arguments)
            end
          end
        end
      end
      context 'when the automated ticket have been active for less than 5 minutes' do
        it 'should not notify the user' do
          expect(VehicleAtRiskNotification).not_to receive(:with)
          subject
        end
      end
    end
    context 'when there is some tickets in the database' do
      let(:freeze_time_at) { [2004, 11, 24, 0o1, 0o4, 44] }
      let!(:ticket) do
        travel_to Time.new(*freeze_time_at) do
          FactoryBot.create(:ticket,
                            ends_on: minutes_ago.minutes.ago,
                            automated_ticket_id: automated_ticket.id,
                            zipcode: '75018')
        end
      end
      let(:minutes_ago) { 2 }
      context 'when the last ticket has ended more than 5 minutes ago' do
        let(:minutes_ago) { 6 }

        context 'when the user have not been notified already' do
          let(:expected_enqued_job_arguments) do
            {
              'notification_class' => 'Admin::VehicleAtRiskNotification',
              'options' => {
                'class' => 'DeliveryMethods::Discord',
                'channel' => {
                  '_aj_serialized' => 'ActiveJob::Serializers::SymbolSerializer',
                  'value' => 'vehicle_at_risk'
                },
                '_aj_symbol_keys' => %w[class channel]
              },
              'params' => {
                'user_email' => user.email,
                'license_plate' => automated_ticket.license_plate,
                'zipcode' => '75018',
                'uncovered_since' => {
                  '_aj_serialized' => 'ActiveJob::Serializers::TimeWithZoneSerializer',
                  'value' => '2004-11-23T23:58:44.000000000Z'
                },
                'automated_ticket_id' => automated_ticket.id,
                '_aj_symbol_keys' => %w[user_email license_plate zipcode uncovered_since automated_ticket_id]
              },
              'recipient' => { '_aj_globalid' => "gid://pervenche/User/#{user.id}" },
              'record' => { '_aj_globalid' => an_instance_of(String) },
              '_aj_symbol_keys' => %w[notification_class options params recipient record]
            }
          end
          it 'should notify the user' do
            expect { subject }.to change(Sidekiq::Queues['default'], :size).from(0).to(1)
            enqueded_job = Sidekiq::Queues['default'].dig(0, 'args', 0, 'job_class')
            enqueded_job_arguments = Sidekiq::Queues['default'].dig(0, 'args', 0, 'arguments', 0)
            expect(enqueded_job).to eq('DeliveryMethods::Discord')
            expect(enqueded_job_arguments).to match(expected_enqued_job_arguments)
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
    end
  end
end
