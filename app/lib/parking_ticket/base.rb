# typed: strict
# frozen_string_literal: true

require 'date'

module ParkingTicket
  class Base
    extend T::Sig
    class << self
      extend T::Sig

      sig do
        params(
          adapter_name: String,
          username: String,
          password: String
        )
          .returns(T::Boolean)
      end
      def valid_credentials?(adapter_name, username, password)
        adapter_class = Clients::PayByPhone::Adapter if adapter_name == 'pay_by_phone'
        raise Error, 'EasyPark will be handled in the next major release' if adapter_name == 'easy_park'
        raise Error, "Unhandled adapter : #{adapter_name}" unless adapter_class

        adapter_class.valid_credentials?(username, password)
      end
    end

    class Error < StandardError
    end

    sig do
      params(
        adapter_name: String,
        username: String,
        password: String
      )
        .void
    end
    def initialize(adapter_name, username, password)
      @username = username
      @password = password
      @adapter = T.let(load_adapter!(adapter_name), ParkingTicket::Clients::PayByPhone::Adapter)
    end

    sig { returns(T::Array[ParkingTicket::Clients::Models::Vehicle]) }
    def vehicles
      @adapter.vehicles
    end

    sig { params(zipcode: String, license_plate: String).returns(T::Array[ParkingTicket::Clients::Models::RateOption]) }
    def rate_options(zipcode, license_plate)
      @adapter.rate_options(zipcode, license_plate)
    end

    sig { params(license_plate: String, zipcode: String).returns(T.nilable(ParkingTicket::Clients::Models::Ticket)) }
    def running_ticket(license_plate, zipcode)
      @adapter.running_ticket(license_plate, zipcode)
    end

    sig { returns(T::Array[ParkingTicket::Clients::Models::PaymentMethod]) }
    def payment_methods
      @adapter.payment_methods
    end

    sig do
      params(
        rate_option_id: String,
        zipcode: String,
        license_plate: String,
        quantity: Integer,
        time_unit: String
      )
        .returns(ParkingTicket::Clients::Models::Quote)
    end
    def quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
      @adapter.quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
    end

    sig do
      params(
        license_plate: String,
        zipcode: String,
        rate_option_client_internal_id: String,
        quantity: Integer,
        time_unit: String,
        payment_method_id: T.nilable(String)
      ).void
    end
    def new_ticket(license_plate:, zipcode:, rate_option_client_internal_id:, quantity:, time_unit:, payment_method_id:)
      @adapter.new_ticket(
        license_plate:,
        zipcode:,
        rate_option_client_internal_id:,
        quantity: 1,
        time_unit:,
        payment_method_id:
      )
    end

    private

    sig { params(adapter_name: String).returns(ParkingTicket::Clients::PayByPhone::Adapter) }
    def load_adapter!(adapter_name)
      return Clients::PayByPhone::Adapter.new(@username, @password) if adapter_name == 'pay_by_phone'
      raise Error, 'EasyPark will be handled in the next major release' if adapter_name == 'easy_park'

      raise Error, "Unhandled adapter : #{adapter_name}"
    end
  end
end
