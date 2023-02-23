class OnboardingsController < ApplicationController
  def show
    @service_set_up = current_user.services.any?
  end
end
