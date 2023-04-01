namespace :automated_ticket do
  desc 'This task will save a new ticket or renew a ticket if needed'
  task renew_ticket_if_required: :environment do
    return unless Rails.env.production?
    tickets_to_renew = AutomatedTicket.missing_running_tickets_in_database
    if tickets_to_renew.empty?
      puts 'All robots have a running ticket in database'
    else
      tickets_to_renew.each do |(automated_ticke_id, zipcode)|
        puts "Checking automated_ticket #{automated_ticke_id}"
        AutomatedTicket::Renewer.call(automated_ticket_id:, zipcode:)
        puts "automated_ticket #{automated_ticke_id} checked"
      end
    end
  end
end
