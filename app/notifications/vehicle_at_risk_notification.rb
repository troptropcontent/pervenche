# To deliver this notification:
#
# VehicleAtRiskNotification.with(post: @post).deliver_later(current_user)
# VehicleAtRiskNotification.with(post: @post).deliver(current_user)

class VehicleAtRiskNotification < Noticed::Base
  deliver_by :database

  param :user_email
  param :license_plate
  param :zipcode
  param :uncovered_since
  param :automated_ticket_id

  after_deliver :notify_admin

  class << self
    def all
      Notification.all.where(type: 'VehicleAtRiskNotification')
    end

    def last_uncovered_since_notified(automated_ticket, zipcode)
      all.where("(params ->> 'automated_ticket_id')::integer = ? AND params ->> 'zipcode' = ?",
                automated_ticket.id,
                zipcode)
         .order(Arel.sql(
                  "COALESCE(((params -> 'uncovered_since') ->> 'value') , (params->>'uncovered_since'))::timestamp ASC"
                ))
         .pick(Arel.sql(
                 "COALESCE(((params -> 'uncovered_since') ->> 'value') , (params->>'uncovered_since'))::timestamp ASC"
               ))
    end
  end

  private

  def notify_admin
    Admin::VehicleAtRiskNotification.with(params).deliver_later(recipient)
  end
end
