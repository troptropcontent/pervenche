# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutomatedTickets::Static::RegisteredRateOption, type: :model do
  describe 'instance methods' do
    describe 'to_rate_option' do
      it 'convert a registered_rate_option into a ParkingTicket::Clients::Models::RateOption' do
        expect(described_class.last.to_rate_option).to eq(ParkingTicket::Clients::Models::RateOption.new(
                                                            accepted_time_units: %w[days],
                                                            client_internal_id: '75100',
                                                            free: true,
                                                            name: 'Paris - Handi',
                                                            type: 'CMI'
                                                          ))
      end
    end
  end
end
