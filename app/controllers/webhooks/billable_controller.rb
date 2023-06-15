# frozen_string_literal: true
# typed: true

class Webhooks::BillableController < ApplicationController
  extend T::Sig
  skip_before_action :authenticate_user!, :verify_authenticity_token
  skip_load_and_authorize_resource
  before_action :authenticate_token

  # POST /webhooks/billable/:token
  def handle
    content = params[:content]
    webhook_type = params[:event_type].to_s
    process_webhook_later(webhook_type, content)
    render plain: 'OK'
  end

  private

  def authenticate_token
    render plain: 'Unauthorized', status: :unauthorized unless params[:token].to_s == Billable.webhook_token
  end

  sig do
    params(
      webhook_type: String,
      content: T.nilable(T.any(String, Numeric, ActionController::Parameters))
    ).void
  end
  def process_webhook_later(webhook_type, content)
    return unless webhook_type.start_with?('subscription')

    serialized_content = content.to_json

    Billable::Webhook::SubscriptionJob.perform_async(webhook_type, serialized_content)
  end
end
