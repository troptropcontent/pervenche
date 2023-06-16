# frozen_string_literal: true
# typed: true

module AutomatedTicket::Setup
  class LoadData < Actor
    extend T::Sig

    input :automated_ticket, type: AutomatedTicket
    input :params, type: [Hash, ActionController::Parameters]
    input :step, type: Symbol
    output :data

    def call
      self.data = {}
      load_data_required_for_service_step if step == :service
      load_data_required_for_kind_step if step == :kind
      load_data_required_for_zipcodes_step if step == :zipcodes
      load_data_required_for_vehicle_step if step == :vehicle
      load_data_required_for_rate_option_step if step == :rate_option
      load_data_required_for_payment_methods_step if step == :payment_methods
      load_data_required_for_subscription_step if step == :subscription
    end

    private

    def load_data_required_for_service_step
      data.merge!({
                    services: automated_ticket.user.services.pluck(:name, :id)
                  })
    end

    def load_data_required_for_kind_step
      data.merge!({
                    kinds: automated_ticket.kinds_allowed
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
                                                                        automated_ticket.license_plate,
                                                                        automated_ticket.localisation,
                                                                        automated_ticket.kind,
                                                                        automated_ticket.vehicle_type)

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
      item_price_id = ChargeBee::ITEM_PRICE_IDS.dig(
        automated_ticket.vehicle_type, automated_ticket.kind
      )

      charge_bee_subscription = ChargeBee::Subscription.create_with_items(automated_ticket.user.chargebee_customer_id, {
                                                                            cf_automated_ticket_id: automated_ticket.id,
                                                                            subscription_items: [{
                                                                              item_price_id:
                                                                            }]
                                                                          }).subscription

      charge_bee_item_price = ChargeBee::ItemPrice.retrieve(item_price_id).item_price

      data.merge!({
                    charge_bee_subscription_id: charge_bee_subscription.id,
                    charge_bee_item_price_external_name: charge_bee_item_price.external_name,
                    charge_bee_item_price_price: Money.new(charge_bee_item_price.price,
                                                           charge_bee_item_price.currency_code),
                    charge_bee_item_price_period: charge_bee_item_price.period_unit,
                    charge_bee_item_price_trial_period: charge_bee_item_price.trial_period,
                    charge_bee_item_price_trial_period_unit: charge_bee_item_price.trial_period_unit
                  })
    end

    sig { returns(AutomatedTickets::Setup) }
    def setup
      automated_ticket.setup
    end
  end
end
