class TicketToRenew < ApplicationRecord
  belongs_to :automated_ticket
  default_scope { order(automated_ticket_id: :desc, uncovered_since: :asc) }

  def readonly?
    true
  end

  def notifications
    Notification.where(
      "type = 'VehicleAtRiskNotification' AND params->>'automated_ticket_id' = ?::text AND params->>'zipcode' = ? AND ((params -> 'uncovered_since') ->> 'value')::timestamp >= ?", automated_ticket_id, zipcode, uncovered_since
    ).order(:created_at)
  end
end
