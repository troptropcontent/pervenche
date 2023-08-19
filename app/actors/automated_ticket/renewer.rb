# frozen_string_literal: true

class AutomatedTicket::Renewer < Actor
  input :jid, default: nil
  play ->(actor) { actor.automated_ticket ||= AutomatedTicket.find(actor.automated_ticket_id) },
       FindOrSaveRunningTicket
  play FindPaymentMethod,
       FindTimeUnitAndQuantity,
       RequestNewTicket,
       if: lambda { |actor|
             actor.running_ticket.nil? &&
               actor.automated_ticket.should_renew_today? &&
               (actor.last_request_on.nil? || actor.last_request_on <= 5.minutes.ago)
           }
  play NotifyVehicleAtRiskIfNeeded
  # TO_DO make last_request_on 0 if null this way we can simply do actor.last_request_on <= 5.minutes.ago
end
