# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module Models
      class Quote < T::Struct
        include ParkingTicket::Clients::Models::StructuralyComparable
        const :client_internal_id, String
        const :starts_on, DateTime
        const :ends_on, DateTime
        const :cost, Float
      end
    end
  end
end
