# frozen_string_literal: true

module AutomatedTicket::Setup
  class LoadData < Actor
    input :automated_ticket
    input :params
    input :step
    output :data

    def call
      self.data = {}
      load_data_required_for_service_step if step == :service
      load_data_required_for_zipcodes_step if step == :zipcodes
      load_data_required_for_vehicle_step if step == :vehicle
      load_data_required_for_rate_option_step if step == :rate_option
      load_data_required_for_payment_methods_step if step == :payment_methods
    end

    private

    def load_data_required_for_service_step
      self.data = {
        services: automated_ticket.user.services.pluck(:name, :id)
      }
    end

    def load_data_required_for_vehicle_step
      self.data = {
        vehicles: automated_ticket.service.vehicles
      }
    end

    def load_data_required_for_rate_option_step
      self.data = {
        rate_options: automated_ticket.service.rate_options(automated_ticket.zipcodes, automated_ticket.license_plate)

      }
    end

    def load_data_required_for_payment_methods_step
      self.data = {
        payment_methods: automated_ticket.service.payment_methods
      }
    end

    def load_data_required_for_zipcodes_step
      self.data = {
        localisation: params.permit(:localisation)[:localisation]
      }
    end
  end
end
