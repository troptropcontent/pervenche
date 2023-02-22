class Service < ApplicationRecord
  belongs_to :user
  has_many :automated_tickets
  encrypts :username, :password
  enum :kind, {
    pay_by_phone: 0,
    easy_park: 1
  }

  validates :username, uniqueness: { scope: :kind }
  validates_presence_of :kind, :username, :password
  validate :valid_credentials

  def vehicles
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{username}/vehicles", expires_in: 1.minutes) do
      client.vehicles
    end
  end

  def rate_options(zipcode, license_plate)
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{zipcode}/#{license_plate}/rate_options",
                      expires_in: 1.minutes) do
      client.rate_options(zipcode, license_plate)
    end
  end

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

  def request_new_ticket!(license_plate, zipcode, rate_option_id, quantity, time_unit, payment_method_id:)
    client.new_ticket(license_plate, zipcode, rate_option_id, quantity, time_unit, payment_method_id: payment_method_id)
  end

  def quote(rate_option_id, zipcode, license_plate, quantity, time_unit)
    Rails.cache.fetch("#{cache_key_with_version}/#{kind}/#{username}/#{license_plate}/#{rate_option_id}/#{quantity}/#{time_unit}/quote",
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
end
