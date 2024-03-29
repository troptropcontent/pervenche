# frozen_string_literal: true

module AutomatedTickets
  class UseParams < Actor
    input :automated_ticket, type: AutomatedTicket
    input :automated_ticket_params, type: ActionController::Parameters
    output :saved_changes
    def call
      save_initial_attributes
      fail!(error: automated_ticket.errors.full_messages) unless automated_ticket.update(automated_ticket_params)
      self.saved_changes = automated_ticket.saved_changes
    end

    def rollback
      automated_ticket.update(@initial_automated_ticket_attributes)
    end

    def save_initial_attributes
      @initial_automated_ticket_attributes = automated_ticket.attributes
    end
  end
end
