class Robot < ApplicationRecord
  belongs_to :service
  encrypts :license_plate, :payment_method, :zipcode
  validates_presence_of :name, :license_plate, :payment_method, :zipcode

  def current_ticket
    client.current_ticket
  end

  private

  def client
    @client ||= ParkingTicket::Base.new(
      service.kind,
      {
        username: service.username,
        password: service.password,
        license_plate: license_plate,
        zipcode: zipcode,
        card_number: payment_method
      }
    )
  end
end
