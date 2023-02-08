class AutomatedTicket < ApplicationRecord
  belongs_to :service, optional: true
  belongs_to :user

  SETUP_STEPS = {
    service: [:service_id],
    license_plate_and_zipcode: %i[license_plate zipcode],
    rate_option: %i[rate_option_client_internal_id client_time_unit],
    duration_and_payment_method: %i[minutes payment_method_client_internal_id]
  }.freeze

  enum status: {
    initialized: 0,
    setup: 1,
    ready: 2
  }

  with_options if: -> { required_for_step?(:service) } do
    validates :service_id, presence: true
  end

  with_options if: -> { required_for_step?(:license_plate_and_zipcode) } do
    validates :license_plate, :zipcode, presence: true
  end

  with_options if: -> { required_for_step?(:rate_option) } do
    validates :rate_option_client_internal_id, :client_time_unit, presence: true
  end

  with_options if: -> { required_for_step?(:duration_and_payment_method) } do
    validates :payment_method_client_internal_id, :minutes, presence: true
  end

  attr_accessor :setup_step

  def self.setup_steps
    SETUP_STEPS
  end

  private

  def required_for_step?(step)
    return true unless setup_step

    ordered_steps = self.class.setup_steps.keys
    !!(ordered_steps.index(step) <= ordered_steps.index(setup_step))
  end
end
