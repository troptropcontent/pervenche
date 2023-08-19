# typed: true
# frozen_string_literal: true

class AutomatedTickets::RenewerJob
  extend T::Sig
  include Sidekiq::Job

  # we can disable the retry here as it is a cron job that is exected every minutes
  sidekiq_options retry: false, queue: :critical

  sig do
    params(automated_ticket_id: Integer, zipcode: String).void
  end
  def perform(automated_ticket_id, zipcode)
    instrumentation_data = { jid:, automated_ticket_id:, zipcode: }
    ActiveSupport::Notifications.instrument 'job.automated_tickets.renewer_job.main', instrumentation_data do
      last_request_on = TicketRequest.where(automated_ticket_id:).maximum(:requested_on) || DateTime.new
      running_ticket = Ticket.find_by(automated_ticket_id:, zipcode:, ends_on: Time.zone.now..)
      return if running_ticket.present?

      AutomatedTicket::Renewer.call(automated_ticket_id:, zipcode:, last_request_on:, jid:)
    end
  end
end
