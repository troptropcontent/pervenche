module Robots
  class RenewTicketIfRequiredService
    def initialize(robot)
      @robot = robot
      @result = 'started'
    end

    def call
      return 'ticket_found_in_database' if @robot.running_ticket_in_database?

      if @robot.running_ticket_in_client?
        @robot.save_running_ticket_from_client!
        'ticket_found_in_client_and_saved_in_database'
      else
        @robot.renew
        'new_ticket_requested'
      end
    end
  end
end
