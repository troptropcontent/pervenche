# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    # all common signed in abilities goes here

    return unless user.has_role?('customer')

    # all customer abilities goes here
    can %i[new], AutomatedTicket
    can %i[show reset], AutomatedTicket, { user:, status: %i[started setup] }
    can %i[update], AutomatedTicket, { user: }
    can %i[index destroy], AutomatedTicket, { user_id: user.id, status: :ready }
    can %i[new create update], Service, { user_id: user.id }
    can %i[show], Billing::Customer do |customer|
      user.chargebee_customer_id == customer.client_id
    end
    can %i[edit update], Billing::Address do |address|
      user.chargebee_customer_id == address.customer.client_id
    end

    return unless user.has_role?('admin')

    # all admin abilities goes here
    can %i[dashboard], :admin
    can %i[show], Admin::Diagnostics::Client
    can %i[show], Admin::Diagnostics::TicketsToRenew
  end
end
