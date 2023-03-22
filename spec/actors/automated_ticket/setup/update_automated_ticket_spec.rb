# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_context/a_user_with_a_service_with_an_automated_ticket'

RSpec.describe AutomatedTicket::Setup::UpdateAutomatedTicket, type: :actor do
  include_context 'a user with a service with an automated ticket'
  let(:step) {'service'}
  let(:anothet_service) do
    service = FactoryBot.build(:service, user:)
    service.save(validate: false)
    service
end
  let(:params) {{service_id: anothet_service.id}}
  subject {described_class.call(automated_ticket:, step:, params:)}
  describe '.call' do
    it "set the step non persisted atribut and updates the automated_ticket" do
      result = subject
      expect(subject.automated_ticket.setup_step).to eq('service')
      expect(subject.automated_ticket.service).to eq(anothet_service)
    end
  end
end
