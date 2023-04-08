require 'active_support/concern'

module HasRoles
  extend ActiveSupport::Concern
  HANDLED_ROLES = %w[customer admin].freeze

  included do
    validate :uniq_values
    validate :handled_roles_only

    scope :customer, -> { where(':role = ANY (roles)', role: 'customer') }
    scope :admin, -> { where(':role = ANY (roles)', role: 'admin') }

    def add_role(role)
      return if roles.include?(role)

      roles << role
      save!
    end

    def remove_role(role)
      return unless roles.include?(role)

      roles.delete(role)
      save!
    end

    private

    def uniq_values
      return if roles.uniq == roles

      errors.add(
        :roles,
        I18n.t(
          "activerecord.errors.models.#{model_name.singular}.attributes.roles.duplicate_value"
        )
      )
    end

    def handled_roles_only
      unhandled_role = nil
      return unless roles.any? { |role| unhandled_role = role if HANDLED_ROLES.exclude?(role) }

      errors.add(
        :roles,
        I18n.t(
          "activerecord.errors.models.#{model_name.singular}.attributes.roles.handled_roles_only",
          unhandled_role:
        )
      )
    end
  end
end
