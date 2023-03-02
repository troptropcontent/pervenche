class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :require_operationnal, if: :operationnal_controller?
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
    redirect_to(onboarding_path) && return unless current_user.operationnal?
  end

  private

  def operationnal_controller?
    !devise_controller? && %w[onboardings
                              setups].exclude?(controller_name) && %w[new create update].exclude?(action_name)
  end

  def require_navbar
    @with_navbar = true
  end
end
