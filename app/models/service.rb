class Service < ApplicationRecord
  belongs_to :user
  has_many :robots
  encrypts :username, :password
  enum :kind, {
    pay_by_phone: 0
  }

  validate :valid_credentials
  validates_presence_of :name, :username, :password

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

  private

  def valid_credentials
    return if ParkingTicket::Base.valid_credentials?(kind, username, password)

    errors.add(:credentials, I18n.t('models.service.validations.credentials'))
  end

  def client
    ParkingTicket::Base.new(kind, username, password)
  end
end
