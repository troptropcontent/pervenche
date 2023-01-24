class Robot < ApplicationRecord
  belongs_to :service
  encrypts :license_plate, :payment_method, :zipcode
  validates_presence_of :name, :license_plate, :payment_method, :zipcode
end
