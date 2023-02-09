class AutomatedTickets::SetupsController < ApplicationController
  before_action :load_automated_ticket
  before_action :load_step!
  before_action :authorize_access!

  # GET /automated_tickets/:automated_ticket_id/setups/:id
  def show
    @automated_ticket.setup_step = @step
    if step_already_completed?
      redirect_to_next_step!
    else
      load_data_required_for_step
      @submit_path = automated_ticket_setup_path(@automated_ticket.id, @step)
      render @step
    end
  end

  def update
    @automated_ticket.setup_step = @step
    if @automated_ticket.update(permited_params_for_step)
      redirect_to_next_step!
    else
      load_data_required_for_step
      @submit_path = automated_ticket_setup_path(@automated_ticket.id, @step)
      render @step
    end
  end

  private

  def load_automated_ticket
    @automated_ticket = AutomatedTicket.find(params[:automated_ticket_id])
  end

  def load_step!
    if AutomatedTicket.setup_steps[params[:id].to_sym]
      @step = params[:id]
    else
      not_found
    end
  end

  def authorize_access!
    authorize! :setup, @automated_ticket
  end

  def next_step
    @next_step ||= AutomatedTicket.setup_steps.keys[AutomatedTicket.setup_steps.keys.index(@step.to_sym) + 1]
  end

  def redirect_to_next_step!
    redirect_to automated_ticket_setup_path(@automated_ticket.id, next_step)
  end

  def step_already_completed?
    @automated_ticket.valid?.tap do
      @automated_ticket.errors.clear
    end
  end

  def permited_params_for_step
    params.require(:automated_ticket).permit(AutomatedTicket.setup_steps[@step.to_sym])
  end

  def load_data_required_for_step
    load_data_required_for_service_step if @step == 'service'
    load_data_required_for_license_plate_and_zipcode_step if @step == 'license_plate_and_zipcode'
    load_data_required_for_rate_option_step if @step == 'rate_option'
    load_data_required_for_duration_and_payment_method_step if @step == 'duration_and_payment_method'
  end

  def load_data_required_for_service_step
    @services = current_user.services.pluck(:name, :id)
  end

  def load_data_required_for_license_plate_and_zipcode_step
    @vehicles = @automated_ticket.service.vehicles
  end

  def load_data_required_for_rate_option_step
    # @rate_options = @automated_ticket.service.rate_options(@automated_ticket.zipcode, @automated_ticket.license_plate)
    @rate_options = [{ client_internal_id: '75101', name: 'Résident', type: 'RES', accepted_time_units: 'days' },
                     { client_internal_id: '1085252721', name: 'Voiture - Visiteur - 75012-75020', type: 'CUSTOM', accepted_time_units: 'minutes' }, { client_internal_id: '1085252721', name: 'Voiture - Visiteur - 75012-75020', type: 'CUSTOM', accepted_time_units: 'hours' }]
  end

  def load_data_required_for_duration_and_payment_method_step; end
end
