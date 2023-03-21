# frozen_string_literal: true

class AutomatedTicket::Setup::Updater::CompleteAlreadyCompletableSteps < Actor
  input :automated_ticket
  output :automated_ticket
  def call
    next_completable_step = find_uncompleted_and_completable_step
    until next_completable_step.nil?
      automated_ticket.save!
      next_completable_step = find_uncompleted_and_completable_step
    end
  end

  private

  def find_next_uncompleted_step
    AutomatedTicket.setup_steps.keys.find do |step|
      automated_ticket.setup_step = step
      automated_ticket.invalid?
    end
  end

  def find_uncompleted_and_completable_step
    AutomatedTicket.setup_steps.keys.find do |step|
      automated_ticket.setup_step = step
      automated_ticket.invalid? && completable_step?(step)
    end
  end

  def completable_step?(step)
    return service_step_completable? if step == :service
    return localisation_step_completable? if step == :localisation
    return vehicle_step_completable? if step == :vehicle
    return rate_option_completable? if step == :rate_option
    return weekdays_completable? if step == :weekdays
    return payment_methods_completable? if step == :payment_methods

    false
  end

  def first_uncompleted_step
    AutomatedTicket.setup_steps.keys.find do |step|
      automated_ticket.setup_step = step
      automated_ticket.invalid?
    end
  end

  def localisation_step_completable?
    automated_ticket.assign_attributes(
      {
        localisation: 'paris'
      }
    )

    automated_ticket.valid?
  end

  def service_step_completable?
    services = automated_ticket.user.services
    return false if services.count != 1

    automated_ticket.assign_attributes(
      {
        service_id: services[0].id
      }
    )

    automated_ticket.valid?
  end

  def vehicle_step_completable?
    vehicles = automated_ticket.service&.vehicles || []
    return false if vehicles.count != 1

    automated_ticket.assign_attributes(
      {
        license_plate: vehicles.dig(0, :license_plate),
        vehicle_type: vehicles.dig(0, :vehicle_type),
        vehicle_description: vehicles.dig(0, :vehicle_description)
      }
    )

    automated_ticket.valid?
  end

  def rate_option_completable?

    rate_options = automated_ticket.rate_options_shared_between_zipcodes
    return false if rate_options.count != 1

    automated_ticket.assign_attributes(
      {
        rate_option_client_internal_id: rate_options.dig(0, :client_internal_id),
        accepted_time_units: rate_options.dig(0, :accepted_time_units),
        free: rate_options.dig(0, :free)
      }
    )

    automated_ticket.valid?
  end

  def weekdays_completable?
    return false unless automated_ticket.free

    automated_ticket.assign_attributes(
      {
        weekdays: [0, 1, 2, 3, 4, 5, 6]
      }
    )

    automated_ticket.valid?
  end

  def payment_methods_completable?
    payment_methods = automated_ticket.service&.payment_methods || []
    return false if !automated_ticket.free && payment_methods.count != 1

    automated_ticket.assign_attributes(
      {
        payment_method_client_internal_ids: [payment_methods.dig(0, :client_internal_id)]
      }
    )

    automated_ticket.valid?
  end
end
