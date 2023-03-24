# frozen_string_literal: true

class AutomatedTicket::Setup::LoadData < Actor
  input :automated_ticket
  input :step
  output :data
  def call
    self.data = {}
    load_data_required_for_service_step if step == :service
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
      rate_options: automated_ticket.rate_options_shared_between_zipcodes
    }
  end

  def load_data_required_for_payment_methods_step
    self.data = {
      payment_methods: automated_ticket.service.payment_methods
    }
  end
end