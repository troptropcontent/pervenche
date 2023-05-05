# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
require 'support/shared_context/with_environment_variable'

RSpec.describe AutomatedTicket::RenewTask, type: :actor do
  Sidekiq::Testing.fake!
  describe '.call' do
    subject { described_class.call }
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
    context 'when some automated_tickets does not have a ticket for a zipcode' do
      context 'when PERVENCHE_RENEW_TICKET is set' do
        include_examples 'with an environment variable', 'PERVENCHE_RENEW_TICKET', 'true'
        let(:expected_job_arguments) do
          [
            [automated_ticket.id, '75018', '-4712-01-01T00:00:00+00:00'],
            [automated_ticket.id, '75017', two_minutes_ago.to_s],
            [automated_ticket.id, '75016', '-4712-01-01T00:00:00+00:00']
          ]
        end
        let!(:two_minutes_ago) do
          2.minutes.ago
        end
        let!(:ticket_request_sent_for_75017) do
          FactoryBot.create(:ticket_request, zipcode: '75017', automated_ticket_id: automated_ticket.id,
                                             requested_on: two_minutes_ago)
        end
        it 'enqueue the relevant jobs' do
          expect { subject }.to change(AutomatedTickets::RenewerJob.jobs, :size).by(3)
          enqueued_job_arguments = AutomatedTickets::RenewerJob.jobs.pluck('args')
          expect(enqueued_job_arguments).to contain_exactly(*expected_job_arguments)
        end
      end
      context 'when PERVENCHE_RENEW_TICKET is not set' do
        it 'does not enqueue any job' do
          expect { subject }.to change(AutomatedTickets::RenewerJob.jobs, :size).by(0)
        end
      end
    end
    context 'when all automated_tickets have a ticket for each zipcodes' do
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
      it 'does not enqueue any job' do
        expect { subject }.to change(AutomatedTickets::RenewerJob.jobs, :size).by(0)
      end
    end
  end
end
