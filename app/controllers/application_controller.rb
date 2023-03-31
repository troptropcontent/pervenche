# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning, :success
  before_action :authenticate_user!
  before_action :require_operationnal, if: :operationnal_required?
  before_action :require_navbar

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    not_found
  end
  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def require_operationnal
    redirect_to(onboarding_path)
  end

  private

  def operationnal_controller?
    !devise_controller? && %w[onboardings shared_views
                              setups setup].exclude?(controller_name) && %w[new create update].exclude?(action_name)
  end

  def operationnal_required?
    operationnal_controller? && !current_user.operationnal?
  end

  def require_navbar
    @with_navbar = true
  end
end
