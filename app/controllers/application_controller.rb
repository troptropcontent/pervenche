class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end
end
