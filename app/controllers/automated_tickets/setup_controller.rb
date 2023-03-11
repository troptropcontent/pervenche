class AutomatedTickets::SetupController < ApplicationController
  ALLOWED_VEHICLE_TYPES = ['electric_motorcycle']
  ALLOWED_LOCALISATIONS = ['paris']
  ARRAY_FIELDS = %i[weekdays accepted_time_units zipcodes payment_method_client_internal_ids].freeze
  before_action :load_automated_ticket
  before_action :load_step!

  def show
    @with_navbar = false
    @automated_ticket.setup_step = @step
    if step_already_completed?
      redirect_to_next_step!
    else
      load_data_for(step: @step)
      render @step
    end
  end

  def update
    @automated_ticket.setup_step = @step
    if @automated_ticket.update(permited_params_for_step)
      next_step ? redirect_to_next_step! : update_status_and_redirect_to_root!
    else
      load_data_for(step: @step)
      render @step, status: :unprocessable_entity
    end
  end

  private

  def load_automated_ticket
    @automated_ticket = AutomatedTicket.find(params[:automated_ticket_id])
  end

  def load_step!
    if AutomatedTicket.setup_steps[params[:step_name].to_sym]
      @step = params[:step_name]
    else
      not_found
    end
  end

  def next_step
    @next_step ||= AutomatedTicket.setup_steps.keys[AutomatedTicket.setup_steps.keys.index(@step.to_sym) + 1]
  end

  def redirect_to_next_step!
    redirect_to path_for(step: next_step)
  end

  def step_already_completed?
    @automated_ticket.valid?.tap do
      @automated_ticket.errors.clear
    end
  end

  def load_data_for(step:)
    load_vehicle_step_data if step == 'vehicle'
    load_zipcodes_step_data! if step == 'zipcodes'
    load_rate_option_step_data! if step == 'rate_option'
  end

  def load_vehicle_step_data
    @vehicles = @automated_ticket.service.vehicles.filter {|vehicle| ALLOWED_VEHICLE_TYPES.include?(vehicle[:vehicle_type])}
  end

  def load_zipcodes_step_data!
    if ALLOWED_LOCALISATIONS.include?(setup_params[:localisation])
      @localisation = setup_params[:localisation]
    else
      not_found
    end
  end

  def load_rate_option_step_data!
    @rate_options = find_rate_options_shared_between_zipcodes
  end

  def find_rate_options_shared_between_zipcodes
    byebug
    @automated_ticket.zipcodes.map
  end

  def permited_params_for_step
    params.require(:automated_ticket).permit(permitted_fields_for_step)
  end

  def permitted_fields_for_step
    AutomatedTicket.setup_steps[@step.to_sym].map do |field|
      ARRAY_FIELDS.include?(field) ? { field => [] } : field
    end
  end

  def path_for(step:)
    params = base_params(step: step).merge(query_params_for(step: step))
    automated_ticket_setup_path(**params)
  end

  def query_params_for(step:)
    return {localisation: @automated_ticket.localisation} if step.to_sym == :zipcodes
    {}
  end

  def base_params(step:)
    {automated_ticket_id: @automated_ticket.id, step_name: step}
  end

  def setup_params
    params.permit(:localisation)
  end
end
