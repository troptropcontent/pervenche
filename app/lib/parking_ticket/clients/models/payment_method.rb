# typed: true
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module Models
      class PaymentMethod < T::Struct
        include ParkingTicket::Clients::Models::StructuralyComparable
        const :client_internal_id, String
        const :anonymised_card_number, String
        const :payment_card_type, String
      end
    end
  end
end
