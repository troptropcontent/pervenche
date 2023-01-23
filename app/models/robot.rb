class Robot < ApplicationRecord
  belongs_to :service
  encrypts :license_plate, :payment_method, :zipcode
end
