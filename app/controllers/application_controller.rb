# frozen_string_literal: true
# typed: true

class ApplicationController < ActionController::Base
  include ControllerErrorManager

  before_action :authenticate_user!
  load_and_authorize_resource unless: :devise_controller?
  before_action :require_operationnal, if: :operationnal_required?
  before_action :load_menu_links

  def require_operationnal
    redirect_to(onboarding_path)
  end

  private

  def operationnal_controller?
    !devise_controller? &&
      !webhooks_controller? &&
      %w[onboardings shared_views setups setup].exclude?(controller_name) &&
      %w[new create update].exclude?(action_name)
  end

  def operationnal_required?
    operationnal_controller? && !current_user.operationnal?
  end

  def webhooks_controller?
    [Webhooks::BillableController, Webhooks::BillingController].include? self.class
  end

  def load_menu_links
    return unless current_user

    @menu_links = MenuLinksGenerator.call(current_user)
  end
end
