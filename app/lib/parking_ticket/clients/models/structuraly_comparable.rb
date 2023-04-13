# typed: false
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module Models
      module StructuralyComparable
        def ==(other)
          serialize == other.serialize
        end
      end
    end
  end
end
