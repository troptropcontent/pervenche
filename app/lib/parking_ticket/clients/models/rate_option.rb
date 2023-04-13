# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module Models
      class RateOption < T::Struct
        include ParkingTicket::Clients::Models::StructuralyComparable

        const :client_internal_id, String
        const :name, String
        const :type, String
        const :accepted_time_units, T::Array[String]

        prop :free, T.nilable(T::Boolean)
      end
    end
  end
end
