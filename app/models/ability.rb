# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can %i[new], AutomatedTicket
    can %i[setup], AutomatedTicket, { user:, status: %i[initialized setup] }
    can %i[read update], AutomatedTicket, { user:, status: :ready }
    can %i[index create update], Robot, { service: { user: } }
    can %i[new], Robot
    can %i[new create], Service, { user: }
  end
end
