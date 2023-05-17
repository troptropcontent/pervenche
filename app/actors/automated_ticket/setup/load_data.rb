# frozen_string_literal: true
# typed: true

module AutomatedTicket::Setup
  class LoadData < Actor
    extend T::Sig
    include Rails.application.routes.url_helpers
    HOSTS = T.let({
      development: 'localhost:3000',
      test: 'localhost:3000',
      staging: 'app.staging.pervenche.eu',
      production: 'app.pervenche.eu'
    }.freeze, T::Hash[Symbol, String])

    input :automated_ticket, type: AutomatedTicket
    input :params, type: [Hash, ActionController::Parameters]
    input :step, type: Symbol
    output :data

    def call
      load_base_data
      load_data_required_for_service_step if step == :service
      load_data_required_for_zipcodes_step if step == :zipcodes
      load_data_required_for_vehicle_step if step == :vehicle
      load_data_required_for_rate_option_step if step == :rate_option
      load_data_required_for_payment_methods_step if step == :payment_methods
      load_data_required_for_subscription_step if step == :subscription
    end

    private

    def load_base_data
      self.data = {}.tap do |base_data|
        base_data[:previous_step_path] = setup.path_for(step: params[:previous_step]) if previous_step_param_valid?
      end
    end

    def load_data_required_for_service_step
      data.merge!({
                    services: automated_ticket.user.services.pluck(:name, :id)
                  })
    end

    def load_data_required_for_vehicle_step
      data.merge!({
                    vehicles: automated_ticket.service.vehicles_allowed_for(automated_ticket.kind)
                  })
    end

    def load_data_required_for_rate_option_step
      data.merge!({
                    rate_options: automated_ticket.service.rate_options(automated_ticket.zipcodes,
                                                                        automated_ticket.license_plate)

                  })
    end

    def load_data_required_for_payment_methods_step
      data.merge!({
                    payment_methods: automated_ticket.service.payment_methods
                  })
    end

    def load_data_required_for_zipcodes_step
      data.merge!({
                    localisation: automated_ticket.localisation || params.permit(:localisation)[:localisation]
                  })
    end

    def load_data_required_for_subscription_step
      plan_id = automated_ticket.free ? 'electric_scooter' : 'combustion_car'
      charge_bee_subscription_id = params.permit(:id)[:id]
      if charge_bee_subscription_id
        data.merge!({ charge_bee_subscription_id: })
      else
        data.merge!({
                      plan_id:,
                      hosted_page_data: ChargeBee::HostedPage.checkout_new_for_items({
                                                                                       subscription: {
                                                                                         cf_automated_ticket_id: automated_ticket.id
                                                                                       },
                                                                                       subscription_items: [{
                                                                                         item_price_id: "#{plan_id}_eur_monthly"
                                                                                       }],
                                                                                       customer: {
                                                                                         id: automated_ticket.user.chargebee_customer_id,
                                                                                         cf_environment: Rails.env.to_s
                                                                                       },
                                                                                       redirect_url: automated_ticket_setup_url(
                                                                                         host: HOSTS[Rails.env.to_sym],
                                                                                         automated_ticket_id: automated_ticket.id,
                                                                                         step_name: :subscription
                                                                                       ),
                                                                                       type: 'checkout_new'

                                                                                     }).hosted_page.to_json

                    })
      end
    end

    def load_data_required_for_payment_methods_step
      data.merge!({
                    payment_methods: automated_ticket.service.payment_methods
                  })
    end

    sig { returns(T::Boolean) }
    def previous_step_param_valid?
      return false unless params[:previous_step]
      return false unless AutomatedTicket.setup_steps.keys.include?(params[:previous_step].to_sym)

      setup.step_completable?(params[:previous_step])
    end

    sig { returns(AutomatedTickets::Setup) }
    def setup
      automated_ticket.setup(step)
    end
  end
end
