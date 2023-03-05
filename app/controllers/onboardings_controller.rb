class OnboardingsController < ApplicationController
  def show
    @service_set_up = current_user.services.any?
    @automated_ticket_set_up = current_user.automated_tickets.ready.any?
  end
  def welcome
    @with_navbar = false
  end
end
