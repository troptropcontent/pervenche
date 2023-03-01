# frozen_string_literal: true

class AutomatedTicket::Renewer::FindTimeUnitAndQuantity < Actor
  input :automated_ticket
  output :time_unit
  output :quantity
  def call
    self.time_unit = automated_ticket.accepted_time_units.include?('days') ? 'days' : 'hours'
    self.quantity = 1
  end
end
