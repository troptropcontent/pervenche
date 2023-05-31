# frozen_string_literal: true
# typed: true

module AutomatedTickets
  class SetupController < ApplicationController
    extend T::Sig
    skip_load_and_authorize_resource

    before_action :load_automated_ticket
    before_action :load_step!
    before_action :authorize_action!

    # GET /automated_tickets/:automated_ticket_id/setup/:step_name
    def show
      @automated_ticket.setup_step = @step.name

      if @step.completed?(@automated_ticket)
        next_step = @automated_ticket.next_completable_step
        path = next_step ? next_step.show_path(@automated_ticket) : root_path
        redirect_to(path)
      else
        load_instance_variables_for(step: @step)
        render @step.to_s
      end
    end

    # GET /automated_tickets/:automated_ticket_id/setup/:step_name/edit
    def edit
      raise Pervenche::Errors::InvalidState unless @step.completed?(@automated_ticket)

      @automated_ticket.setup_step = @step
      load_instance_variables_for(step: @step)
      render @step.to_s
    end

    # GET /automated_tickets/:automated_ticket_id/setup/:step_name
    def update
      update_automated_ticket!
      if @automated_ticket.valid?
        complete_all_already_completable_steps
        next_step = SetupStep.next_completable_step(@automated_ticket)
        @automated_ticket.update!(status: :ready, active: true) unless next_step
        flash[:notice] = t("views.setup.flash.#{next_step ? 'information_saved' : 'finished'}")
        redirect_to next_step ? next_step.show_path(@automated_ticket) : root_path
      else
        load_instance_variables_for(step: @step)
        flash[:alert] = @automated_ticket.errors.full_messages
        render @step.to_s, status: :unprocessable_entity
      end
    end

    # PUT   /automated_tickets/:automated_ticket_id/setup/:step_name/reset
    def reset
      raise Pervenche::Errors::InvalidState unless @step.before? @automated_ticket.last_completed_step

      @automated_ticket.reset_to(@step)

      redirect_to @step.show_path(@automated_ticket)
    end

    private

    def load_automated_ticket
      @automated_ticket = AutomatedTicket.find(params[:automated_ticket_id])
    end

    def load_step!
      step_name = params[:step_name].to_s.to_sym
      if AutomatedTicket.setup_steps.keys.include?(step_name)
        @step = AutomatedTickets::SetupStep.new(step_name)
      else
        not_found
      end
    end

    def authorize_action!
      authorize! action_name.to_sym, @automated_ticket
    end

    def step_already_completed?
      AutomatedTicket::Setup::StepCompleted.call(automated_ticket: @automated_ticket, step: @step).step_completed
    end

    def data_for(step:)
      AutomatedTicket::Setup::LoadData.call(automated_ticket: @automated_ticket, step:, params:).data
    end

    def next_step
      AutomatedTicket::Setup::FindNextCompletableStep.call(automated_ticket: @automated_ticket).next_step
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

    def path_for(step, previous_step: nil)
      AutomatedTicket::Setup::FindPath.call(automated_ticket: @automated_ticket, step:,
                                            previous_step_param: previous_step).path
    end

    sig { returns(AutomatedTickets::Setup) }
    def setup
      @automated_ticket.setup
    end

    def load_instance_variables_for(step:)
      data_for(step: step.name).each do |name, value|
        instance_variable_set("@#{name}".to_sym, value)
      end
    end

    def automated_ticket_with_all_completable_steps_completed
      AutomatedTicket::Setup::CompleteAlreadyCompletableSteps.call(automated_ticket: @automated_ticket).automated_ticket
    end

    def update_automated_ticket!
      AutomatedTicket::Setup::UpdateAutomatedTicket.call(
        automated_ticket: @automated_ticket,
        step: @step.name,
        params: sanitized_and_permited_automated_ticket_params_for(step: @step.name)
      ).automated_ticket
    end

    def step_completable?
      AutomatedTicket::Setup::StepCompletable.call(
        automated_ticket: @automated_ticket,
        step: @step.to_sym
      ).step_completable
    end

    def complete_all_already_completable_steps
      @automated_ticket = automated_ticket_with_all_completable_steps_completed
    end
  end
end
