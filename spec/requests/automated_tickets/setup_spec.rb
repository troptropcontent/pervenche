# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AutomatedTickets::Setups', type: :request do
  describe '/automated_tickets/:automated_ticket_id/setup/:step_name/edit' do
    context 'GET' do
      describe 'automated_tickets/setup#edit' do
        it 'show the edit version of the step'
      end
    end
  end
  describe '/automated_tickets/:automated_ticket_id/setup/:step_name' do
    context 'GET' do
      describe 'automated_tickets/setup#show' do
        it 'show the setup version of the step'
      end
    end
    context 'PATCH' do
      describe 'automated_tickets/setup#update' do
        it 'updates the automated ticket and redirect to the relevant page'
      end
    end
    context 'PUT' do
      describe 'automated_tickets/setup#update' do
        it 'updates the automated ticket and redirect to the relevant page'
      end
    end
  end
end
