# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can %i[index create], Robot, { service: { user: user } }
    can %i[new], Robot
    can %i[new create], Service, { user: user }
  end
end
