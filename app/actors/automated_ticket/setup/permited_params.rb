# frozen_string_literal: true

class AutomatedTicket::Setup::PermitedParams < Actor
  ARRAY_FIELDS = %i[weekdays accepted_time_units zipcodes payment_method_client_internal_ids].freeze
  input :automated_ticket_params
  input :step
  output :permited_params

  def call
    self.permited_params = automated_ticket_params.permit(permitted_fields_for_step)
  end

  private

  def permitted_fields_for_step
    AutomatedTicket.setup_steps[step.to_sym].map do |field|
      ARRAY_FIELDS.include?(field) ? { field => [] } : field
    end
  end
end
