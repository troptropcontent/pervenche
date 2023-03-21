# frozen_string_literal: true

class AutomatedTicket::Setup::FindPath < Actor
  include Rails.application.routes.url_helpers
  input :automated_ticket
  input :step
  output :path
  def call
    params = base_params(step: step).merge(query_params_for(step: step))
    self.path = automated_ticket_setup_path(**params)
  end

  private

  def query_params_for(step:)
    return {localisation: automated_ticket.localisation} if step.to_sym == :zipcodes
    {}
  end

  def base_params(step:)
    {automated_ticket_id: automated_ticket.id, step_name: step}
  end

  def setup_params
    params.permit(:localisation)
  end
end
