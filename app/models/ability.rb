# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    # all common signed in abilities goes here

    return unless user.has_role?('customer')

    # all customer abilities goes here
    can %i[new], AutomatedTicket
    can %i[show], AutomatedTicket, { user:, status: %i[started setup] }
    can %i[edit], AutomatedTicket, { user:, status: :ready }
    can %i[update], AutomatedTicket, { user: }
    can %i[index destroy], AutomatedTicket, { user_id: user.id, status: :ready }
    can %i[new create], Service, { user_id: user.id }

    return unless user.has_role?('admin')

    # all admin abilities goes here
    can %i[dashboard], :admin
    can %i[show], Admin::Diagnostics::Client
    can %i[show], Admin::Diagnostics::TicketsToRenew
  end
end
