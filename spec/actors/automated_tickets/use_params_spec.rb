# frozen_string_literal: true

require 'rails_helper'

module AutomatedTickets
  RSpec.describe UseParams, type: :actor do
    describe '.call' do
      subject { described_class.call(automated_ticket:, automated_ticket_params:) }
      let!(:automated_ticket) do
        FactoryBot.create(:automated_ticket, :set_up, user:, service:, active: false)
      end
      let(:automated_ticket_params) { ActionController::Parameters.new(params).require(:automated_ticket).permit(:active, :kind) }
      let(:params) { { automated_ticket: { active: true } } }
      let(:user) { FactoryBot.create(:user) }
      let(:service) { FactoryBot.create(:service, :without_validations, user:) }

      context 'when the updated automated ticket is valid' do
        it 'updates the automated_ticket' do
          expect { subject }.to change { automated_ticket.reload.active }.from(false).to(true)
        end
      end
      context 'when the updated automated ticket is not valid' do
        let(:params) { { automated_ticket: { kind: nil } } }
        it 'updates the automated_ticket' do
          expect { subject }.to raise_error(ServiceActor::Failure)
        end
      end
    end
  end
end
