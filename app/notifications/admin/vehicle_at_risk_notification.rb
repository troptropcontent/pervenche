# frozen_string_literal: true

class Admin::VehicleAtRiskNotification < Noticed::Base
  deliver_by :database
  deliver_by :discord, class: 'DeliveryMethods::Discord', channel: :vehicle_at_risk
  param :user_email
  param :license_plate
  param :zipcode
  param :uncovered_since
  param :automated_ticket_id
end
