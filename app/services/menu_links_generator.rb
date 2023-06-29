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
    @links << edit_service_link if @user.operationnal?
    @links << billing_customer_link if @user.operationnal? && billing_customer_feature_allowed?
    @links << subscriptions_link if @user.has_role?('admin')
    @links << dashboard_link if @user.has_role?('admin')
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
      path: edit_service_path(@user.services.first),
      icon: 'settings',
      text: I18n.t('views.application.menu.parking_service')
    )
  end

  def billing_customer_link
    Ui::Link.new(
      path: billing_customer_path(customer_id: @user.chargebee_customer_id),
      icon: 'dollar-sign',
      text: I18n.t('views.application.menu.billing_customer')
    )
  end

  def subscriptions_link
    Ui::Link.new(
      path: billing_subscriptions_path,
      icon: 'dollar-sign',
      text: I18n.t('views.application.menu.subscriptions'),
      color: 'admin'
    )
  end

  def dashboard_link
    Ui::Link.new(
      path: dashboard_admin_path,
      icon: 'chart',
      text: I18n.t('views.application.menu.dashboard'),
      color: 'admin'
    )
  end

  def billing_customer_feature_allowed?
    return true if Rails.env.development?

    allowed_user_ids = ENV['PERVENCHE_BILLING_SECTION_ALLOWED_USER_IDS']&.split(',') || []
    allowed_user_ids.include?(@user.id.to_s)
  end
end
