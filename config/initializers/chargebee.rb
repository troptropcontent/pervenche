# frozen_string_literal: true

ChargeBee.configure(Rails.application.credentials.dig(
                      :chargebee,
                      ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox
                    ))

ChargeBee::ITEM_PRICE_IDS = {
  'combustion_car' => {
    'residential' => 'cc_residential-EUR-Monthly',
    'mobility_inclusion_card' => 'cc_cmi-EUR-Monthly'
  },
  'electric_motorcycle' => {
    'electric_motorcycle' => 'em_standard-EUR-Monthly',
    'mobility_inclusion_card' => 'em_cmi-EUR-Monthly'
  }
}.freeze
