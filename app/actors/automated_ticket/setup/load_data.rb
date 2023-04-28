# frozen_string_literal: true

module AutomatedTicket::Setup
  class LoadData < Actor
    include Rails.application.routes.url_helpers
    HOSTS = {
      development: 'localhost:3000',
      test: 'localhost:3000',
      staging: 'app.staging.pervenche.eu',
      production: 'app.pervenche.eu'
    }.freeze
    input :automated_ticket
    input :params
    input :step
    output :data

    def call
      self.data = {}
      load_data_required_for_service_step if step == :service
      load_data_required_for_zipcodes_step if step == :zipcodes
      load_data_required_for_vehicle_step if step == :vehicle
      load_data_required_for_rate_option_step if step == :rate_option
      load_data_required_for_payment_methods_step if step == :payment_methods
      load_data_required_for_subscription_step if step == :subscription
    end

    private

    def load_data_required_for_service_step
      self.data = {
        services: automated_ticket.user.services.pluck(:name, :id)
      }
    end

    def load_data_required_for_vehicle_step
      self.data = {
        vehicles: automated_ticket.service.vehicles
      }
    end

    def load_data_required_for_rate_option_step
      self.data = {
        rate_options: automated_ticket.service.rate_options(automated_ticket.zipcodes, automated_ticket.license_plate)

      }
    end

    def load_data_required_for_payment_methods_step
      self.data = {
        payment_methods: automated_ticket.service.payment_methods
      }
    end

    def load_data_required_for_zipcodes_step
      self.data = {
        localisation: params.permit(:localisation)[:localisation]
      }
    end

    def load_data_required_for_subscription_step
      plan_id = automated_ticket.free ? 'electric_scooter' : 'combustion_car'
      charge_bee_subscription_id = params.permit(:id)[:id]
      if charge_bee_subscription_id
        self.data = { charge_bee_subscription_id: }
      else
        self.data = {
          plan_id:,
          hosted_page_data: ChargeBee::HostedPage.checkout_new_for_items({
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

        }
      end
    end

    def load_data_required_for_payment_methods_step
      self.data = {
        payment_methods: automated_ticket.service.payment_methods
      }
    end
  end
end
