class RenewOrSaveTicketJob < ApplicationJob
  queue_as :default

  def perform(robot_id)
    robot = Robot.find(robot_id)
    return if robot.running_ticket_in_database?

    if robot.running_ticket_in_client?
      robot.save_running_ticket_from_client!
    else
      robot.renew
    end
  end
end
