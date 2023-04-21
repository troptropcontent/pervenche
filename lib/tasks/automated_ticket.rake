namespace :automated_ticket do
  desc 'This task will save a new ticket or renew a ticket if needed'
  task renew_ticket_if_required: :environment do
    tickets_to_renew = AutomatedTicket.missing_running_tickets_in_database
    return if tickets_to_renew.empty?

    if ENV['PERVENCHE_RENEW_TICKET']
      tickets_to_renew.each do |(automated_ticket_id, zipcode)|
        AutomatedTickets::RenewerJob.perform_async(automated_ticket_id, zipcode)
      end
    end
  end
end
