# typed: strict
# frozen_string_literal: true

module ParkingTicket
  module Clients
    module PayByPhone
      class Adapter
        extend T::Sig

        class << self
          extend T::Sig
          sig { returns(T.class_of(ParkingTicket::Clients::PayByPhone::Client)) }
          def client_class
            ParkingTicket::Clients::PayByPhone::Client
          end

          sig { params(username: String, password: String).returns(T::Boolean) }
          def valid_credentials?(username, password)
            !!client_class.new(username, password).valid_credentials?
          end
        end

        ACCEPTED_TIME_UNIT_MAPPER = T.let({
          'Days' => 'days',
          'Minutes' => 'minutes',
          'Hours' => 'hours'
        }.freeze, T::Hash[String, String])

        PAYMENT_CARD_TYPE_MAPPER = T.let({
          'MasterCard' => 'master_card',
          'Visa' => 'visa'
        }.freeze, T::Hash[String, String])

        VEHICLE_TYPE_MAPPER = T.let({
          'ElectricMotorcycle' => 'electric_motorcycle',
          'Car' => 'combustion_car',
          'HeavyGoodsVehicle' => 'heavy_goods_vehicle',
          'Motorcycle' => 'electric_motorcycle'
        }.freeze, T::Hash[String, String])

        class Error < StandardError; end

        sig { params(username: String, password: String).void }
        def initialize(username, password)
          @username = username
          @password = password
          @valid_credentials = T.let(self.class.valid_credentials?(username, password), T::Boolean)
          @client = T.let(self.class.client_class.new(@username, @password), ParkingTicket::Clients::PayByPhone::Client)
        end

        sig { returns(T::Array[ParkingTicket::Clients::Models::Vehicle]) }
        def vehicles
          raise_invalid_credentials! unless @valid_credentials
          @client.vehicles.map do |vehicle|
            ParkingTicket::Clients::Models::Vehicle.new(
              client_internal_id: vehicle['vehicleId'],
              license_plate: vehicle['licensePlate'],
              vehicle_type: T.must(VEHICLE_TYPE_MAPPER[vehicle['type']]),
              vehicle_description: vehicle.dig('profile', 'description')
            )
          end
        end

        sig do
          params(zipcode: String, license_plate: String).returns(T::Array[ParkingTicket::Clients::Models::RateOption])
        end
        def rate_options(zipcode, license_plate)
          raise_invalid_credentials! unless @valid_credentials
          @client.rate_options(zipcode, license_plate).map do |rate_option|
            mapped_time_units = rate_option['acceptedTimeUnits'].map do |accepted_time_unit|
              ACCEPTED_TIME_UNIT_MAPPER[accepted_time_unit]
            end
            ParkingTicket::Clients::Models::RateOption.new(
              client_internal_id: rate_option['rateOptionId'],
              name: rate_option['name'],
              type: rate_option['type'],
              accepted_time_units: mapped_time_units
            )
          end
        end

        sig do
          params(license_plate: String, zipcode: String).returns(T.nilable(ParkingTicket::Clients::Models::Ticket))
        end
        def running_ticket(license_plate, zipcode)
          raise_invalid_credentials! unless @valid_credentials
          @client.running_tickets.filter do |ticket|
            ticket.dig('vehicle', 'licensePlate') == license_plate && ticket['locationId'] == zipcode
          end.map do |ticket|
            ParkingTicket::Clients::Models::Ticket.new(
              client_internal_id: ticket['parkingSessionId'],
              starts_on: DateTime.parse(ticket['startTime']),
              ends_on: DateTime.parse(ticket['expireTime']),
              license_plate: ticket.dig('vehicle', 'licensePlate'),
              cost: ticket.dig('segments', 0, 'cost'),
              client: 'PayByPhone'
            )
          end.first
        end

        sig do
          returns(T::Array[ParkingTicket::Clients::Models::PaymentMethod])
        end
        def payment_methods
          raise_invalid_credentials! unless @valid_credentials
          @client.payment_methods.fetch('paymentCards').map do |payment_method|
            ParkingTicket::Clients::Models::PaymentMethod.new(
              client_internal_id: payment_method['paymentAccountId'],
              anonymised_card_number: payment_method['maskedCardNumber'][-4..],
              payment_card_type: PAYMENT_CARD_TYPE_MAPPER.fetch(payment_method['cardType'])
            )
          end
        end

        sig do
          params(rate_option_id: String, zipcode: String, license_plate: String, quantity: Integer,
                 time_unit: String).returns(ParkingTicket::Clients::Models::Quote)
        end
        def quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
          raise_invalid_credentials! unless @valid_credentials
          mapped_time_unit = T.must(ACCEPTED_TIME_UNIT_MAPPER.key(time_unit))
          fetched_quote = @client.quote(rate_option_id, zipcode, license_plate, quantity, mapped_time_unit)

          ParkingTicket::Clients::Models::Quote.new(
            client_internal_id: fetched_quote['quoteId'],
            starts_on: DateTime.parse(fetched_quote['parkingStartTime']),
            ends_on: DateTime.parse(fetched_quote['parkingExpiryTime']),
            cost: fetched_quote.dig('totalCost', 'amount').to_f
          )
        end

        sig do
          params(license_plate: String, zipcode: String, rate_option_client_internal_id: String, quantity: Integer,
                 time_unit: String, payment_method_id: T.nilable(String)).void
        end
        def new_ticket(license_plate:, zipcode:, rate_option_client_internal_id:, quantity:, time_unit:,
                       payment_method_id:)
          raise_invalid_credentials! unless @valid_credentials

          mapped_time_unit = ACCEPTED_TIME_UNIT_MAPPER.invert.fetch(time_unit)

          quote = quote(rate_option_client_internal_id, zipcode, license_plate, quantity,
                        time_unit)

          @client.new_ticket(
            license_plate:,
            zipcode:,
            rate_option_client_internal_id:,
            quantity:,
            time_unit: mapped_time_unit,
            quote_client_internal_id: quote.client_internal_id,
            starts_on: quote.starts_on,
            payment_method_id:
          )
        end

        sig { void }
        def raise_invalid_credentials!
          raise Error, 'Adapter credentials are not valid'
        end
      end
    end
  end
end
