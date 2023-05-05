# frozen_string_literal: true

module Admin::Diagnostics
  class TicketsToRenew
    def checkup
      {
        total_number_of_taken_ticket:,
        total_number_of_tickets_to_take:,
        total: total_number_of_taken_ticket + total_number_of_tickets_to_take
      }
    end

    private

    def tickets_to_be_taken
      @tickets_to_be_taken ||= AutomatedTicket.unnested_with_running_tickets.where(active: true, status: :ready)
    end

    def total_number_of_taken_ticket
      @total_number_of_taken_ticket ||= tickets_to_be_taken.where.not(running_tickets: { id: nil }).size
    end

    def total_number_of_tickets_to_take
      @total_number_of_tickets_to_take ||= tickets_to_be_taken.where(running_tickets: { id: nil }).size
    end
  end
end
