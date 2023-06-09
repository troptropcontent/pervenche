# frozen_string_literal: true
# typed: strict

module AutomatedTickets
  module AutoCompletable
    extend T::Sig
    sig { params(name: Symbol, automated_ticket: AutomatedTicket).returns(T::Hash[Symbol, T.untyped]) }
    def auto_completable_attributes(name, automated_ticket)
      return service_auto_completable_attributes(automated_ticket) if name == :service
      return localisation_auto_completable_attributes if name == :localisation
      return zipcodes_auto_completable_attributes(automated_ticket) if name == :zipcodes
      return rate_option_auto_completable_attributes(automated_ticket) if name == :rate_option
      return weekdays_auto_completable_attributes if name == :weekdays
      return payment_methods_auto_completable_attributes(automated_ticket) if name == :payment_methods

      {}
    end

    private

    sig { returns(T::Hash[Symbol, T::Array[Integer]]) }
    def weekdays_auto_completable_attributes
      {
        weekdays: [0, 1, 2, 3, 4, 5, 6]
      }
    end

    sig { params(automated_ticket: AutomatedTicket).returns(T::Hash[Symbol, T::Array[String]]) }
    def zipcodes_auto_completable_attributes(automated_ticket)
      return {} unless automated_ticket.kind == 'mobility_inclusion_card' && automated_ticket.localisation == 'paris'

      {
        zipcodes: ['75100']
      }
    end

    sig { returns(T::Hash[Symbol, T::Array[String]]) }
    def localisation_auto_completable_attributes
      {
        localisation: 'paris'
      }
    end

    sig { params(automated_ticket: AutomatedTicket).returns(T::Hash[Symbol, Integer]) }
    def service_auto_completable_attributes(automated_ticket)
      service_ids = automated_ticket.user.services.pluck(:id)
      return {} unless service_ids.length == 1

      {
        service_id: service_ids.first
      }
    end

    sig { params(automated_ticket: AutomatedTicket).returns(T::Hash[Symbol, T.untyped]) }
    def rate_option_auto_completable_attributes(automated_ticket)
      rate_options = T.let(
        automated_ticket.service.rate_options(automated_ticket.zipcodes,
                                              automated_ticket.license_plate,
                                              automated_ticket.localisation,
                                              automated_ticket.kind,
                                              automated_ticket.vehicle_type),
        T::Array[ParkingTicket::Clients::Models::RateOption]
      )

      if (rate_options.length == 1) && (rate_option = rate_options.first)
        {
          rate_option_client_internal_id: rate_option.client_internal_id,
          accepted_time_units: rate_option.accepted_time_units,
          free: rate_option.free
        }
      else
        {}
      end
    end

    sig { params(automated_ticket: AutomatedTicket).returns(T::Hash[Symbol, String]) }
    def payment_methods_auto_completable_attributes(automated_ticket)
      payment_methods = T.let(
        automated_ticket.service.payment_methods,
        T::Array[ParkingTicket::Clients::Models::PaymentMethod]
      )

      if (payment_methods.length == 1) && (payment_method = payment_methods.first)
        {
          payment_method_client_internal_ids: [payment_method.client_internal_id]
        }
      else
        {}
      end
    end
  end
end
