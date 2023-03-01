# frozen_string_literal: true

class AutomatedTicket::Renewer < Actor
  def call
    play FindOrSaveRunningTicket
    play FindPaymentMethod, 
         FindTimeUnitAndQuantity,
         RequestNewTicket, 
         if: -> actor { actor.running_ticket.nil?}
  end
end
