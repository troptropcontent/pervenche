class Webhooks::ChargeBeeController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token
  skip_load_and_authorize_resource
  before_action :authenticate_token

  # POST /webhooks/charge_bee/:token
  def handle
    content = params[:content]
    webhook_type = params[:event_type]
    handle_webhook_later(webhook_type, content)
    render plain: 'OK'
  end

  private

  def authenticate_token
    expected_token = Rails.application.credentials.dig(
      :chargebee,
      ENV['PERVENCHE_CHARGEBEE_PRODUCTION_SITE'] ? :production : :sandbox,
      :webhooks
    )
    render plain: 'Unauthorized', status: :unauthorized unless params[:token] == expected_token
  end

  def handle_webhook_later(webhook_type, content)
    return unless webhook_type.start_with?('subscription')

    serialized_content = content.to_json
    Webhooks::ChargeBee::Handlers::SubscriptionJob.perform_async(webhook_type, serialized_content)
  end
end
