# frozen_string_literal: true
# typed: true

require Rails.root.join('app/lib/billable')

Billable.configure do |config|
  config.billing_client = :charge_bee
  config.billing_client_configuration = {
    site: Rails.application.credentials.dig(:chargebee,
                                            ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox, :site),
    api_key: Rails.application.credentials.dig(:chargebee,
                                               ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox, :api_key)
  }
  config.webhook_token = Rails.application.credentials.dig(
    :chargebee,
    ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox,
    :webhooks
  )
end
