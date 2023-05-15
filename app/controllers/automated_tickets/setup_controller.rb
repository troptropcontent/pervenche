# frozen_string_literal: true

module AutomatedTickets
  class SetupController < ApplicationController
    skip_load_and_authorize_resource

    before_action :load_automated_ticket
    before_action :load_step!
    before_action :authorize_action!

    def show
      @with_navbar = false
      @automated_ticket.setup_step = @step
      if step_already_completed?
        path = next_step ? path_for(@step) : root_path
        redirect_to(path)
      else
        load_instance_variables_for(step: @step)
        render @step
      end
    end

    def edit
      @with_navbar = false
      @automated_ticket.setup_step = @step
      load_instance_variables_for(step: @step)
      render @step
    end

    def update
      update_automated_ticket!

      if @automated_ticket.valid?
        @automated_ticket = automated_ticket_with_all_completable_steps_completed
        @automated_ticket.update!(status: :ready, active: true) unless next_step
        path = next_step ? path_for(next_step) : root_path
        flash[:notice] = t("views.setup.flash.#{next_step ? 'information_saved' : 'finished'}")
        redirect_to path
      else
        load_instance_variables_for(step: @step)
        flash[:alert] = @automated_ticket.errors.full_messages
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

    def authorize_action!
      authorize! action_name.to_sym, @automated_ticket
    end

    def step_already_completed?
      @automated_ticket.valid?.tap do
        @automated_ticket.errors.clear
      end
    end

    def data_for(step:)
      AutomatedTicket::Setup::LoadData.call(automated_ticket: @automated_ticket, step:, params:).data
    end

    def next_step
      AutomatedTicket::Setup::FindNextStep.call(automated_ticket: @automated_ticket).next_step
    end

    def permited_automated_ticket_params_for(step:)
      AutomatedTicket::Setup::PermitedParams.call(
        automated_ticket_params: params.require(:automated_ticket),
        step:
      ).permited_params
    end

    def sanitized_and_permited_automated_ticket_params_for(step:)
      permited_params = permited_automated_ticket_params_for(step:)
      SanitizedParams.call(permited_params:).sanitized_params
    end

    def path_for(step)
      AutomatedTicket::Setup::FindPath.call(automated_ticket: @automated_ticket, step:, previous_step_param: @step).path
    end

    def load_instance_variables_for(step:)
      data_for(step: step.to_sym).each do |name, value|
        instance_variable_set("@#{name}".to_sym, value)
      end
    end

    def automated_ticket_with_all_completable_steps_completed
      AutomatedTicket::Setup::CompleteAlreadyCompletableSteps.call(automated_ticket: @automated_ticket).automated_ticket
    end

    def update_automated_ticket!
      AutomatedTicket::Setup::UpdateAutomatedTicket.call(
        automated_ticket: @automated_ticket,
        step: @step.to_sym,
        params: sanitized_and_permited_automated_ticket_params_for(step: @step)
      ).automated_ticket
    end
  end
end
