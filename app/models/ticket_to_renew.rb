class TicketToRenew < ApplicationRecord
  belongs_to :automated_ticket

  def readonly?
    true
  end
end
