namespace :robot do
  desc 'This task will save a new ticket or renew a ticket if needed'
  task renew_ticket_if_required: :environment do
    robots_with_no_ticket_in_database = Robot.where.missing(:running_ticket_in_database)
    if robots_with_no_ticket_in_database.empty?
      puts 'All robots have a running ticket in database'
    else
      robots_with_no_ticket_in_database.find_each do |robot|
        puts "Checking Robot #{robot.id}"
        result = Robots::RenewTicketIfRequiredService.new(robot).call
        puts "Result : #{result}"
      end
    end
  end
end
