namespace :automated_ticket do
  desc 'This task will save a new ticket or renew a ticket if needed'
  task renew_ticket_if_required: :environment do
    AutomatedTicket::RenewTask.call
  end
end
