# frozen_string_literal: true

class OnboardingsController < ApplicationController
  skip_load_and_authorize_resource
  def show
    if current_user.services.any?
      redirect_to new_automated_ticket_path
    else
      @with_navbar = false
      render 'welcome'
    end
  end
end
