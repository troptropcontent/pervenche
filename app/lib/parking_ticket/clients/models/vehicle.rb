# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module Models
      class Vehicle < T::Struct
        include ParkingTicket::Clients::Models::StructuralyComparable

        const :client_internal_id, String
        const :license_plate, String
        const :vehicle_type, String
        const :vehicle_description, T.nilable(String)
      end
    end
  end
end
