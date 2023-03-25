# frozen_string_literal: true

# The Service represent the parking application account
class Service < ApplicationRecord
  belongs_to :user
  has_many :automated_tickets, dependent: :destroy
  encrypts :username, :password
  enum :kind, {
    pay_by_phone: 0,
    easy_park: 1,
    flow_bird: 2
  }

  validates :username, uniqueness: { scope: :kind }
  validates_presence_of :kind, :username, :password
  validate :valid_credentials

  def vehicles
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{username}/vehicles", expires_in: 1.minutes) do
      client.vehicles
    end
  end

  # rubocop:disable Metrics/MethodLength
  def rate_options(zipcodes, license_plate)
    rate_options = zipcodes.map do |zipcode|
      Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{zipcode}/#{license_plate}/rate_options",
                        expires_in: 1.minutes) do
        client.rate_options(zipcode, license_plate)
      end
    end

    shared_rate_option_between_zipcodes = rate_options.flatten.uniq.filter do |rate_option|
      rate_options.all? { |possible_rates| possible_rates.include?(rate_option) }
    end

    shared_rate_option_between_zipcodes.map! do |rate_option|
      rate_option_with_free_property(rate_option, zipcodes, license_plate)
    end
  end
  # rubocop:enable Metrics/MethodLength

  def payment_methods
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{username}/payment_methods", expires_in: 1.minutes) do
      client.payment_methods
    end
  end
  def running_ticket(license_plate, zipcode)
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{username}/#{license_plate}/#{zipcode}/running_ticket",
      expires_in: 1.minutes) do
        client.running_ticket(license_plate, zipcode)
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
  def quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
    # rubocop:disable Layout/LineLength
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{username}/#{license_plate}/#{rate_option_id}/#{quantity}/#{time_unit}/quote",
                      # rubocop:enable Layout/LineLength
                      expires_in: 1.minutes) do
      client.quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
    end
  end

  private

  def valid_credentials
    return if kind && ParkingTicket::Base.valid_credentials?(kind, username, password)

    errors.add(:credentials, I18n.t('models.service.validations.credentials'))
  end

  def client
    ParkingTicket::Base.new(kind, username, password)
  end

  def rate_option_with_free_property(rate_option, zipcodes, license_plate)
    time_unit = rate_option[:accepted_time_units].include?('days') ? 'days' : 'hours'
    rate_option.merge(
      { free: quote(rate_option[:client_internal_id], zipcodes.first, license_plate, 1, time_unit)[:cost].zero? }
    )
  end
end
