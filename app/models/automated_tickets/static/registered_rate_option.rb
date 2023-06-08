# frozen_string_literal: true

module AutomatedTickets
  module Static
    class RegisteredRateOption < ActiveYaml::Base
      set_root_path Rails.root.join('app/models')

      def to_rate_option
        ParkingTicket::Clients::Models::RateOption.new(
          client_internal_id:,
          name:,
          type:,
          accepted_time_units:,
          free:
        )
      end
    end
  end
end
