ParkingTicket::Base.config do |config|
  config.ticket_format = [
    :starts_on,
    :ends_on,
    :license_plate,
    :cost,
    { client_ticket_id: :client_internal_id }
  ]
end
