class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    not_found
  end
  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
