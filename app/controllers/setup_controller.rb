class SetupController < ApplicationController
  def service
    @service = current_user.services.new
    @with_navbar = false
    @redirect_to = localisation_setup_path
    render 'services/new'
  end

  def localisation
  end

  def vehicle
  end

  def zipcode
  end

  def rate_options
  end

  def weekdays
  end

  def payment_methods
  end
end
