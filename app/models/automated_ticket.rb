class AutomatedTicket < ApplicationRecord
  encrypts :payment_method_client_internal_id, :zipcode, :license_plate
  has_many :tickets, dependent: :destroy
  has_many :ticket_requests, dependent: :destroy
  has_one :running_ticket_in_database, -> { running }, class_name: 'Ticket'
  belongs_to :service, optional: true
  belongs_to :user

  SETUP_STEPS = {
    service: [:service_id],
    localisation: [:localisation],
    vehicle: %i[license_plate vehicle_description vehicle_type],
    zipcodes: %i[zipcodes],
    rate_option: %i[rate_option_client_internal_id accepted_time_units free],
    weekdays: %i[weekdays],
    payment_methods: %i[payment_method_client_internal_ids]
  }.freeze

  enum status: {
    initialized: 0,
    setup: 1,
    ready: 2
  }

  with_options if: -> { required_for_step?(:service) } do
    validates :service_id, presence: true
  end

  with_options if: -> { required_for_step?(:localisation) } do
    validates :localisation, presence: true
  end

  with_options if: -> { required_for_step?(:vehicle) } do
    validates :license_plate, :vehicle_type, presence: true
  end

  with_options if: -> { required_for_step?(:zipcodes) } do
    validates :zipcodes, length: { minimum: 1, message: I18n.t('errors.messages.empty_array') }
  end

  with_options if: -> { required_for_step?(:rate_option) } do
    validates :rate_option_client_internal_id, :accepted_time_units, presence: true
  end

  with_options if: -> { required_for_step?(:weekdays) } do
    validates :weekdays, length: { minimum: 1, message: I18n.t('errors.messages.empty_array') }
  end

  with_options if: -> { required_for_step?(:payment_methods) } do
    validates :payment_method_client_internal_ids,
              length: { minimum: 1, message: I18n.t('errors.messages.empty_array') }, unless: :free
  end

  attr_accessor :setup_step

  def self.setup_steps
    SETUP_STEPS
  end

  def find_or_create_running_ticket_if_it_exists
    return running_ticket_in_database if running_ticket_in_database

    ticket_to_save = running_ticket_in_client
    tickets.create!(running_ticket_in_client.except(:client)) if ticket_to_save
  end

  def running_ticket_in_client
    service.running_ticket(license_plate, zipcode)
  end

  def free?
    time_unit = accepted_time_units.include?('days') ? 'days' : 'hours'
    service.quote(rate_option_client_internal_id, zipcodes[0], license_plate, 1, time_unit)[:cost].zero?
  end

  def coverage
    return 'covered' if running_ticket
    return 'day_not_covered' unless should_renew_today?

    'not_covered'
  end

  def running_ticket
    return running_ticket_in_database if running_ticket_in_database

    return unless ticket_to_save = running_ticket_in_client

    tickets.create(ticket_to_save.except(:client))
  end

  def renew!(quantity:, time_unit:, payment_method_client_internal_id:)
    service.request_new_ticket!(
      license_plate:,
      zipcode:,
      rate_option_client_internal_id:,
      quantity: 1,
      time_unit:,
      payment_method_id: payment_method_client_internal_id
    )
  end

  def should_renew_today?
    weekdays.include?(Date.today.wday)
  end

  def rate_options_shared_between_zipcodes
    return [] unless service_id && license_plate && zipcodes

    rate_options = zipcodes.map do |zipcode|
      service.rate_options(zipcode, license_plate)
    end

    rate_options.flatten.uniq.filter do |rate_option|
      rate_options.all? { |possible_rates| possible_rates.include?(rate_option) }
    end
  end

  def next_uncompleted_step; end

  private

  def required_for_step?(step)
    return true unless setup_step

    ordered_steps = self.class.setup_steps.keys
    !!(ordered_steps.index(step) <= ordered_steps.index(setup_step.to_sym))
  end
end
