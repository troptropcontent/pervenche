class Robot < ApplicationRecord
  belongs_to :service
  has_many :tickets
  has_one :running_ticket_in_database, -> { running }, class_name: 'Ticket'
  encrypts :license_plate, :payment_method, :zipcode
  validates_presence_of :name, :license_plate, :payment_method, :zipcode

  def running_ticket_in_client?
    !!running_ticket_in_client
  end

  def running_ticket_in_database?
    !!running_ticket_in_database
  end

  def running_ticket_in_client
    @running_ticket_in_client ||= client.current_ticket
  end

  def save_running_ticket_from_client!
    running_ticket_in_client && tickets.create!(running_ticket_in_client)
  end

  def renew
    !running_ticket_in_client? && client.renew
  end

  private

  def client
    @client ||= ParkingTicket::Base.new(
      service.kind,
      {
        username: service.username,
        password: service.password,
        license_plate:,
        zipcode:,
        card_number: payment_method
      }
    )
  end
end
