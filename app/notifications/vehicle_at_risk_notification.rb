# To deliver this notification:
#
# VehicleAtRiskNotification.with(post: @post).deliver_later(current_user)
# VehicleAtRiskNotification.with(post: @post).deliver(current_user)

class VehicleAtRiskNotification < Noticed::Base
  deliver_by :database
  param :coverage_ended_on
  param :automated_ticket
  param :zipcode
end
