# frozen_string_literal: true

class AutomatedTicket::Renewer::NotifyVehicleAtRiskIfNeeded < Actor
  ACCEPTED_UNCOVERED_MINUTES = 5
  input :automated_ticket
  input :zipcode
  input :jid, default: nil

  def call
    notify_error if vehicle_at_risk? && !already_notified?
  end

  private

  def notify_error
    VehicleAtRiskNotification.with(
      user_email: automated_ticket.user.email,
      license_plate: automated_ticket.license_plate,
      zipcode:,
      uncovered_since:,
      automated_ticket_id: automated_ticket.id
    ).deliver_later(automated_ticket.user)
  end

  def vehicle_at_risk?
    uncovered_since < ACCEPTED_UNCOVERED_MINUTES.minutes.ago
  end

  def already_notified?
    return false if last_uncovered_since_notified.nil?

    uncovered_since <= last_uncovered_since_notified
  end

  def uncovered_since
    @uncovered_since ||= Ticket.where(automated_ticket:,
                                      zipcode:)
                               .order(ends_on: :desc)
                               .pick(:ends_on) || automated_ticket.last_activated_at
  end

  def last_uncovered_since_notified
    @last_uncovered_since_notified ||= VehicleAtRiskNotification.last_uncovered_since_notified(
      automated_ticket, zipcode
    )
  end
end
