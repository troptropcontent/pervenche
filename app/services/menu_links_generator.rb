# frozen_string_literal: true
# typed: strict

class MenuLinksGenerator
  extend T::Sig
  include Rails.application.routes.url_helpers

  sig { params(user: User).void }
  def initialize(user)
    @user = user
    @links = T.let([], T::Array[Ui::Link])
  end

  sig { params(user: User).returns(T::Array[Ui::Link]) }
  def self.call(user)
    new(user).call
  end

  def call
    @links << logout_link
    @links << edit_service_link if service
    @links
  end

  private

  sig { returns(Ui::Link) }
  def logout_link
    Ui::Link.new(
      path: destroy_user_session_path,
      action: :delete,
      icon: 'log_out',
      text: I18n.t('views.application.menu.log_out')
    )
  end

  sig { returns(Ui::Link) }
  def edit_service_link
    Ui::Link.new(
      path: edit_service_path(service),
      icon: 'settings',
      text: I18n.t('views.application.menu.parking_service')
    )
  end

  sig { returns(T.nilable(Service)) }
  def service
    @service ||= T.let(@user.services.first, T.nilable(Service))
  end
end
