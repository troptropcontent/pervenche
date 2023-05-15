# frozen_string_literal: true

class AutomatedTicket::Setup::FindPath < Actor
  include Rails.application.routes.url_helpers
  input :automated_ticket
  input :step
  input :previous_step_param, default: -> {}
  output :path
  def call
    params = base_params(step:).merge(query_params_for(step:))
    self.path = automated_ticket_setup_path(**params)
  end

  private

  def query_params_for(step:)
    return { localisation: automated_ticket.localisation } if step.to_sym == :zipcodes

    {}
  end

  def base_params(step:)
    { automated_ticket_id: automated_ticket.id, step_name: step, previous_step: previous_step_param }
  end
end
