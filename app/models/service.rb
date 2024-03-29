# frozen_string_literal: true
# typed: true

# The Service represent the parking application account
class Service < ApplicationRecord
  SUPPORTED_RATE_OPTION_TYPES = %w[RES VP-2RM CMI].freeze
  TICKET_KINDS_ALLOWED_VEHICLE_TYPES = {
    residential: ['combustion_car'],
    electric_motorcycle: ['electric_motorcycle'],
    mobility_inclusion_card: %w[combustion_car combustion_motorcycle electric_motorcycle],
    custom: %w[combustion_car combustion_motorcycle electric_motorcycle]
  }.freeze

  belongs_to :user
  has_many :automated_tickets, dependent: :destroy
  # encrypts :username, :password, deterministic: true
  encrypts :username, :password, deterministic: true
  enum :kind, {
    pay_by_phone: 0,
    easy_park: 1,
    flow_bird: 2
  }

  validates :username, uniqueness: { scope: :kind }
  validates :username, phone: true

  validates :kind, :username, :password, presence: true
  validate :valid_credentials

  delegate :payment_methods, to: :client

  delegate :running_ticket, to: :client

  delegate :quote, to: :client

  delegate :vehicles, to: :client

  def vehicles_allowed_for(automated_ticket_kind)
    allowed_vehycle_types = TICKET_KINDS_ALLOWED_VEHICLE_TYPES[automated_ticket_kind.to_sym]
    vehicles.filter do |vehicle|
      allowed_vehycle_types.include?(vehicle.vehicle_type)
    end
  end

  def rate_options(zipcodes, license_plate, localisation, kind, vehicle_type)
    registered_rate_options = registered_rate_options(zipcodes:, localisation:, kind:, vehicle_type:)
    return registered_rate_options if registered_rate_options.present?

    rate_options = zipcodes.map do |zipcode|
      client.rate_options(zipcode, license_plate).filter do |rate_option|
        SUPPORTED_RATE_OPTION_TYPES.include?(rate_option.type)
      end
    end
    rate_options_unique = rate_options.flatten.uniq(&:serialize)
    shared_rate_option_between_zipcodes = rate_options_unique.filter do |rate_option|
      rate_options.all? { |possible_rates| possible_rates.include?(rate_option) }
    end

    shared_rate_option_between_zipcodes.map! do |rate_option|
      rate_option_with_free_property(rate_option, zipcodes, license_plate)
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def request_new_ticket!(license_plate:, zipcode:, rate_option_client_internal_id:, time_unit:, payment_method_id:,
                          quantity: 1)
    client.new_ticket(
      license_plate:,
      zipcode:,
      rate_option_client_internal_id:,
      quantity:,
      time_unit:,
      payment_method_id:
    )
  end

  # rubocop:enable Metrics/ParameterLists

  private

  def valid_credentials
    return if (kind && username && password) && ParkingTicket::Base.valid_credentials?(kind, username, password)

    errors.add(:username, I18n.t('models.service.validations.username'))
    errors.add(:password, I18n.t('models.service.validations.password'))
  end

  def client
    ParkingTicket::Base.new(kind, username, password)
  end

  def rate_option_with_free_property(rate_option, zipcodes, license_plate)
    time_unit = rate_option.accepted_time_units.include?('days') ? 'days' : 'hours'
    rate_option.free = quote(rate_option.client_internal_id, zipcodes.first, license_plate, 1, time_unit).cost.zero?
    rate_option
  end

  def registered_rate_options(zipcodes:, localisation:, kind:, vehicle_type:)
    registered_rate_options = AutomatedTickets::Static::RegisteredRateOption.where(localisation:, kind:)
    registered_rate_options.filter! do |registered_rate_option|
      zipcodes.all? { |zipcode| registered_rate_option.elligible_zipcodes.include?(zipcode) } &&
        registered_rate_option.elligible_vehicle_types.include?(vehicle_type)
    end
    registered_rate_options.map!(&:to_rate_option)
  end
end
