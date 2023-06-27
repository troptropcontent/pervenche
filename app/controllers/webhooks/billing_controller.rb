module Webhooks
  class BillingController < ApplicationController
    skip_before_action :authenticate_user!, :verify_authenticity_token
    skip_load_and_authorize_resource
    before_action :authenticate_token

    # POST /webhooks/billing/:token
    def handle
      content = params[:content]
      webhook_type = params[:event_type].to_s
      process_webhook_later(webhook_type, content)
      render plain: 'OK'
    end

    private

    def process_webhook_later(webhook_type, content)
      return unless webhook_type.start_with?('payment')

      serialized_content = content.to_json

      Billing::Webhook::PaymentJob.perform_async(webhook_type,
                                                 serialized_content)
    end

    def authenticate_token
      render plain: 'Unauthorized', status: :unauthorized unless params[:token].to_s == Billable.webhook_token
    end
  end
end
