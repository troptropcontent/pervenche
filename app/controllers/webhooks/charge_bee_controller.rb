class Webhooks::ChargeBeeController < ApplicationController
  skip_before_action :authenticate_user!, :verify_authenticity_token
  skip_load_and_authorize_resource
  before_action :authenticate_token

  def handle
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
end
