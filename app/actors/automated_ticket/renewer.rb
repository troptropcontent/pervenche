# frozen_string_literal: true

class AutomatedTicket::Renewer < Actor
  def call
    play FindOrSaveRunningTicket
    play FindPaymentMethod, 
         FindTimeUnitAndQuantity,
         RequestNewTicket, 
         if: -> actor { actor.running_ticket.nil? && actor.automated_ticket.should_renew_today? }
  end
end
