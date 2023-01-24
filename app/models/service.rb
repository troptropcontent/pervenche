class Service < ApplicationRecord
  belongs_to :user
  has_many :robots
  encrypts :username, :password
  enum :kind, {
    pay_by_phone: 0
  }

  validate :valid_credentials
  validates_presence_of :name, :username, :password

  private

  def valid_credentials
    return if ParkingTicket::Base.valid_credentials?(kind, username, password)

    errors.add(:credentials, I18n.t('models.service.validations.credentials'))
  end
end
