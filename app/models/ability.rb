# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can %i[new], AutomatedTicket
    can %i[setup], AutomatedTicket, { user:, status: %i[started setup] }
    can %i[read update destroy], AutomatedTicket, { user:, status: :ready }
    can %i[new create], Service, { user: }
  end
end
