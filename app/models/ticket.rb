class Ticket < ApplicationRecord
  belongs_to :automated_ticket
  monetize :cost_cents

  scope :running, -> { where(ends_on: Time.zone.now..) }
  # Ex:- scope :active, -> {where(:active => true)}
end
