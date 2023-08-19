# frozen_string_literal: true

module AutomatedTickets
  class UpdateLastUpdatedAt < Actor
    input :automated_ticket, type: AutomatedTicket
    def call
      save_initial_last_activated_at
      automated_ticket.update(last_activated_at: Time.zone.now)
    end

    def rollback
      automated_ticket.update(last_activated_at: @initial_last_activated_at)
    end

    private

    def save_initial_last_activated_at
      @initial_last_activated_at = automated_ticket.last_activated_at
    end
  end
end
