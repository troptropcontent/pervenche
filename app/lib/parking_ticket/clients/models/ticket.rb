# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module Models
      class Ticket < T::Struct
        include ParkingTicket::Clients::Models::StructuralyComparable

        const :client_internal_id, String
        const :starts_on, DateTime
        const :ends_on, DateTime
        const :license_plate, String
        const :cost, Float
        const :client, String
      end
    end
  end
end
