namespace :automated_ticket do
  desc 'This task will save a new ticket or renew a ticket if needed'
  task renew_ticket_if_required: :environment do
    automated_tickets = AutomatedTicket.where.missing(:running_ticket_in_database).where(active: true, status: :ready)
    if automated_tickets.empty?
      puts 'All robots have a running ticket in database'
    else
      automated_tickets.find_each do |automated_ticket|
        puts "Checking automated_ticket #{automated_ticket.id}"
        AutomatedTicket::Renewer.call(automated_ticket:)
        puts "automated_ticket #{automated_ticket.id} checked"
      end
    end
  end
end
