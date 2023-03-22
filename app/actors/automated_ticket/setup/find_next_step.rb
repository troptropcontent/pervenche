# frozen_string_literal: true

class AutomatedTicket::Setup::FindNextStep < Actor
  input :automated_ticket
  output :next_step
  def call
    self.next_step = AutomatedTicket.setup_steps.keys.find do |step|
      automated_ticket.setup_step = step
      automated_ticket.invalid?
    end
  end
end
