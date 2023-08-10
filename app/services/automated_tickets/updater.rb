# frozen_string_literal: true

module AutomatedTickets
  class Updater < ApplicationService
    attr_reader :automated_ticket, :automated_ticket_params

    def initialize(automated_ticket, _automated_ticket_params)
      @automated_ticket = automated_ticket
    end

    def call
      automated_ticket.transaction(joinable: false) do
        automated_ticket.update!(automated_ticket_params)
        execute_callbacks!
      end
    end

    private

    def execute_callbacks!
      pause_subscription! if automated_ticket.saved_change_to_active = [true, false]
      resume_subscription! if automated_ticket.saved_change_to_active = [false, true]
    end

    def pause_subscription!
      Pauser.call(automated_ticket)
    end

    def resume_subscription!
      Resumer.call(automated_ticket)
    end
  end
end
