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
    client.vehicles
  end

  def rate_options(zipcode, license_plate)
    client.rate_options(zipcode, license_plate)
  end

  def payment_methods
    client.payment_methods
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
