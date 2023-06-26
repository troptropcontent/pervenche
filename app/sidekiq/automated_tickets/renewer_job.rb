# typed: true
# frozen_string_literal: true

class AutomatedTickets::RenewerJob
  extend T::Sig
  include Sidekiq::Job

  sig do
    params(automated_ticket_id: Integer, zipcode: String).void
  end
  def perform(automated_ticket_id, zipcode)
    last_request_on = TicketRequest.where(automated_ticket_id:).maximum(:requested_on) || DateTime.new
    running_ticket = Ticket.find_by(automated_ticket_id:, zipcode:, ends_on: Time.zone.now..)
    return if running_ticket.present?

    AutomatedTicket::Renewer.call(automated_ticket_id:,
                                  zipcode:,
                                  last_request_on:)
  end
end
