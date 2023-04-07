# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AutomatedTickets', type: :request do
  describe '/automated_tickets' do
    context 'GET' do
      describe 'automated_tickets#index' do
        it 'returns the index'
      end
    end
  end

  describe '/automated_tickets/new' do
    context 'GET' do
      describe 'automated_tickets#new' do
        it 'returns the automated_ticket wizard'
      end
    end
  end

  describe '/automated_tickets/:id' do
    context 'PATCH' do
      describe 'automated_tickets#update' do
        it 'updates the automated_ticket'
      end
    end
    context 'PUT' do
      describe 'automated_tickets#update' do
        it 'updates the automated_ticket'
      end
    end
    context 'DELETE' do
      describe 'automated_tickets#destroy' do
        it 'destroys the automated_ticket'
      end
    end
  end
end
