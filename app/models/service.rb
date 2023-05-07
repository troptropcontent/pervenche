# frozen_string_literal: true

# The Service represent the parking application account
class Service < ApplicationRecord
  SUPPORTED_RATE_OPTION_TYPES = %w[RES VP-2RM CMI].freeze
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

  def rate_options(zipcodes, license_plate)
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
end
