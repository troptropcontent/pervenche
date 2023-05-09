# frozen_string_literal: true

class AutomatedTicket::RenewTask < Actor
  def call
    tickets_to_renew = AutomatedTicket.missing_running_tickets_in_database
                                      .pluck('automated_tickets.id',
                                             'unnested_automated_tickets.zipcode',
                                             'last_ticket_request_dates.last_requested_on')

    return unless tickets_to_renew.length.positive? && ENV['PERVENCHE_RENEW_TICKET']

    tickets_to_renew.each do |(automated_ticket_id, zipcode)|
      AutomatedTickets::RenewerJob.perform_async(automated_ticket_id, zipcode)
    end
  end
end
