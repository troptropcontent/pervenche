class AutomatedTicket < ApplicationRecord
  encrypts :payment_method_client_internal_id, :zipcode, :license_plate
  has_many :tickets
  has_one :running_ticket_in_database, -> { running }, class_name: 'Ticket'
  belongs_to :service, optional: true
  belongs_to :user

  SETUP_STEPS = {
    service: [:service_id],
    license_plate_and_zipcode: %i[license_plate zipcode],
    rate_option: %i[rate_option_client_internal_id accepted_time_units],
    duration_and_payment_method: %i[weekdays payment_method_client_internal_id]
  }.freeze

  enum status: {
    initialized: 0,
    setup: 1,
    ready: 2
  }

  validates :license_plate, uniqueness: { scope: %i[user_id service_id] }, if: :license_plate

  with_options if: -> { required_for_step?(:service) } do
    validates :service_id, presence: true
  end

  with_options if: -> { required_for_step?(:license_plate_and_zipcode) } do
    validates :license_plate, :zipcode, presence: true
  end

  with_options if: -> { required_for_step?(:rate_option) } do
    validates :rate_option_client_internal_id, :accepted_time_units, presence: true
  end

  with_options if: -> { required_for_step?(:duration_and_payment_method) } do
    validates :payment_method_client_internal_id, :weekdays, presence: true
  end

  attr_accessor :setup_step

  def self.setup_steps
    SETUP_STEPS
  end

  def running_ticket_in_client
    service.running_ticket(license_plate, zipcode)
  end

  def renew!
    time_unit = accepted_time_units.include?('days') ? 'days' : 'hours'
    service.request_new_ticket!(license_plate, zipcode, rate_option_client_internal_id, 1, time_unit,
                                payment_method_client_internal_id)
  end

  private

  def required_for_step?(step)
    return true unless setup_step

    ordered_steps = self.class.setup_steps.keys
    !!(ordered_steps.index(step) <= ordered_steps.index(setup_step.to_sym))
  end
end
