# frozen_string_literal: true

module Admin::Diagnostics
  class Client
    class << self
      def vehicles(service)
        check { service.vehicles }
      end

      def rate_options(service)
        automated_ticket = service.automated_tickets.ready.sample
        zipcodes = [automated_ticket.zipcodes.sample]
        license_plate = automated_ticket.license_plate
        check { service.rate_options(zipcodes, license_plate) }
      end

      def payment_methods(service)
        check { service.payment_methods }
      end

      def running_ticket(service)
        automated_ticket = service.automated_tickets.ready.sample
        zipcode = automated_ticket.zipcodes.sample
        license_plate = automated_ticket.license_plate
        check { service.running_ticket(license_plate, zipcode) }
      end

      def quote(service)
        automated_ticket = service.automated_tickets.ready.sample
        zipcode = automated_ticket.zipcodes.sample
        license_plate = automated_ticket.license_plate
        rate_option_id = automated_ticket.rate_option_client_internal_id
        quantity = 1
        time_unit = automated_ticket.accepted_time_units.sample
        check { service.quote(rate_option_id, zipcode, license_plate, quantity, time_unit) }
      end

      private

      def check
        begin
          yield
        rescue Faraday::ClientError => e
          return 'Fail'
        end
        'Ok'
      end
    end

    def initialize(service)
      @service = service
    end

    def checkup
      {
        vehicles:, rate_options:, payment_methods:, running_ticket:, quote:
      }
    end

    def vehicles
      @vehicles ||= self.class.vehicles(@service)
    end

    def rate_options
      @rate_options ||= self.class.rate_options(@service)
    end

    def payment_methods
      @payment_methods ||= self.class.payment_methods(@service)
    end

    def running_ticket
      @running_ticket ||= self.class.running_ticket(@service)
    end

    def quote
      @quote ||= self.class.quote(@service)
    end
  end
end
