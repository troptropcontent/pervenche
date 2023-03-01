class AutomatedTicket < ApplicationRecord
  encrypts :payment_method_client_internal_id, :zipcode, :license_plate
  has_many :tickets, dependent: :destroy
  has_many :ticket_requests, dependent: :destroy
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

  def find_or_create_running_ticket_if_it_exists
    return running_ticket_in_database if running_ticket_in_database
    ticket_to_save = running_ticket_in_client
    tickets.create!(running_ticket_in_client.except(:client)) if ticket_to_save
  end
    

  def running_ticket_in_client
    service.running_ticket(license_plate, zipcode)
  end

  def free?
    time_unit = accepted_time_units.include?('days') ? 'days' : 'hours'
    service.quote(rate_option_client_internal_id, zipcode, license_plate, 1, time_unit)[:cost].zero?
  end

  def coverage
    return 'covered' if running_ticket
    return 'day_not_covered' if weekdays.exclude?(Date.today.wday)

    'not_covered'
  end

  def running_ticket
    @running_ticket = if running_ticket_in_database
                        running_ticket_in_database
                      elsif (ticket_to_save = running_ticket_in_client)
                        tickets.create(ticket_to_save.except(:client))
                      end
  end

  def renew!(quantity: , time_unit: , payment_method_client_internal_id:)
    service.request_new_ticket!(
      license_plate: license_plate,
      zipcode: zipcode,
      rate_option_client_internal_id: rate_option_client_internal_id,
      quantity: 1,
      time_unit: time_unit,
      payment_method_id: payment_method_client_internal_id
    )
  end

  private

  def required_for_step?(step)
    return true unless setup_step

    ordered_steps = self.class.setup_steps.keys
    !!(ordered_steps.index(step) <= ordered_steps.index(setup_step.to_sym))
  end
end
