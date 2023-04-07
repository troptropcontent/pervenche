# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Services', type: :request do
  describe '/services' do
    context 'POST' do
      describe 'services#create' do
        it 'creates a new service'
      end
    end
  end
  describe '/services/new' do
    context 'GET' do
      describe 'services#new' do
        it 'returns the new service page'
      end
    end
  end
end
