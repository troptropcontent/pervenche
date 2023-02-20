module AutomatedTickets
  class Renewer
    def initialize(automated_ticket)
      @automated_ticket = automated_ticket
    end

    def call
      if running_ticket_in_database
        result = 'ticket_found_in_database'
      elsif running_ticket_in_client
        save_ticket_from_client_in_database!
        result = 'ticket_found_in_client_and_saved_in_database'
      elsif should_renew?
        request_new_ticket!
        result = 'new_ticket_requested'
      else
        result = 'no_ticket_needed'
      end
      result
    end

    private

    def running_ticket_in_client
      @running_ticket_in_client ||= @automated_ticket.running_ticket_in_client
    end

    def running_ticket_in_database
      @running_ticket_in_client ||= @automated_ticket.running_ticket_in_database
    end

    def should_renew?
      @automated_ticket.weekdays.include?(Date.today.wday)
    end

    def save_ticket_from_client_in_database!
      @automated_ticket.tickets.create(running_ticket_in_client.except(:client))
    end

    def request_new_ticket!
      @automated_ticket.renew!
    end
  end
end
