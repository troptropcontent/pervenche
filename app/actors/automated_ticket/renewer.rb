# frozen_string_literal: true

class AutomatedTicket::Renewer < Actor
  play ->(actor) { actor.automated_ticket ||= AutomatedTicket.find(actor.automated_ticket_id) },
       FindOrSaveRunningTicket
  play FindPaymentMethod,
       FindTimeUnitAndQuantity,
       RequestNewTicket,
       if: ->(actor) { actor.running_ticket.nil? && actor.automated_ticket.should_renew_today? }
end
