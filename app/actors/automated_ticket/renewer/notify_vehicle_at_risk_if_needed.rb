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
    (uncovered_since < ACCEPTED_UNCOVERED_MINUTES.minutes.ago) && in_paying_slot?
  end

  def already_notified?
    return false if last_uncovered_since_notified.nil?

    uncovered_since <= last_uncovered_since_notified
  end

  def uncovered_since
    @uncovered_since ||= find_uncovered_since
  end

  def find_uncovered_since
    return last_activated_at if last_ticket_ends_on.nil? || last_ticket_ends_on.before?(last_activated_at)

    last_ticket_ends_on
  end

  def last_ticket_ends_on
    @last_ticket_ends_on ||= Ticket.where(automated_ticket:, zipcode:)
                                   .order(ends_on: :desc)
                                   .pick(:ends_on)
  end

  def last_activated_at
    automated_ticket.last_activated_at
  end

  def last_uncovered_since_notified
    @last_uncovered_since_notified ||= VehicleAtRiskNotification.last_uncovered_since_notified(
      automated_ticket, zipcode
    )
  end

  def in_paying_slot?
    paying_slot_starts_at = ActiveSupport::TimeZone['Paris'].parse('09:00:00')
    paying_slot_stops_at = ActiveSupport::TimeZone['Paris'].parse('20:00:00')
    Time.zone.now.between?(paying_slot_starts_at, paying_slot_stops_at)
  end
end
