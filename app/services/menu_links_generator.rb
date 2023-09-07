# frozen_string_literal: true
# typed: strict

class MenuLinksGenerator
  extend T::Sig
  include Rails.application.routes.url_helpers

  sig { params(current_user: User, true_user: T.nilable(User)).void }
  def initialize(current_user, true_user)
    @current_user = current_user
    @true_user = true_user
    @links = T.let([], T::Array[Ui::Link])
  end

  sig { params(current_user: User, true_user: T.nilable(User)).returns(T::Array[Ui::Link]) }
  def self.call(current_user, true_user)
    new(current_user, true_user).call
  end

  def call
    @links << logout_link
    @links << edit_service_link if @current_user.operationnal?
    @links << billing_customer_link if @current_user.operationnal?
    @links << subscriptions_link if @current_user.has_role?('admin')
    @links << dashboard_link if @current_user.has_role?('admin')
    @links << automated_tickets_without_tickets_link if @current_user.has_role?('admin')
    @links << export_link if @current_user.has_role?('admin')
    @links << emails_link if @current_user.has_role?('admin')
    @links << back_to_admin_link if @current_user != @true_user
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
      path: edit_service_path(@current_user.services.first),
      icon: 'settings',
      text: I18n.t('views.application.menu.parking_service')
    )
  end

  def billing_customer_link
    Ui::Link.new(
      path: billing_customer_path(customer_id: @current_user.chargebee_customer_id),
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

  def automated_tickets_without_tickets_link
    Ui::Link.new(
      path: automated_tickets_without_tickets_admin_path,
      icon: 'alert-triangle',
      text: I18n.t('views.application.menu.automated_tickets_without_tickets'),
      color: 'admin'
    )
  end

  def export_link
    Ui::Link.new(
      path: export_automated_tickets_path(format: :csv),
      icon: 'table',
      text: I18n.t('views.application.menu.export'),
      color: 'admin'
    )
  end

  def emails_link
    Ui::Link.new(
      path: emails_templates_path,
      icon: 'mail',
      text: I18n.t('views.application.menu.emails'),
      color: 'admin'
    )
  end

  def back_to_admin_link
    Ui::Link.new(
      action: :post,
      path: stop_impersonating_users_path,
      icon: 'repeat',
      text: I18n.t('views.application.menu.back_to_admin'),
      color: 'admin'
    )
  end
end
