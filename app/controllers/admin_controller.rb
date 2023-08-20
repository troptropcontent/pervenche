# frozen_string_literal: true

class AdminController < ApplicationController
  skip_load_and_authorize_resource
  before_action :authorize_action!

  def dashboard
    @users_onboarded_count = User.joins(:automated_tickets).where(automated_tickets: { status: :ready }).distinct.count
  end

  def automated_tickets_without_tickets
    @ticket_to_renews = TicketToRenew.all
  end

  private

  def authorize_action!
    authorize! action_name.to_sym, :admin
  end
end
