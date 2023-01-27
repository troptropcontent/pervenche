class RenewTicketsJob < ApplicationJob
  queue_as :default

  def perform
    Robot.where.missing(:running_ticket_in_database).find_each do |robot|
      RenewOrSaveTicketJob.perform_later(robot.id)
    end
  end
end
