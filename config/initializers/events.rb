# typed: strict
# frozen_string_literal: true

ActiveSupport::Notifications.subscribe 'users.created' do |_name, _start, _finish, _id, payload|
  Notifiers::Discord.send_message_later(
    :new_users,
    I18n.t('notifications.discord.new_user', email: payload.fetch('email'))
  )
end

ActiveSupport::Notifications.subscribe 'faraday.errors' do |_name, _start, _finish, _id, payload|
  Notifiers::Discord.send_message_later(
    :errors,
    I18n.t('notifications.discord.faraday.errors',
           method: payload.fetch(:method),
           url: payload.fetch(:url),
           status: payload.fetch(:status),
           body: payload.fetch(:body))
  )
end

ActiveSupport::Notifications.subscribe 'charge_bee.subscription_created' do |_name, _start, _finish, _id, payload|
  Notifiers::Discord.send_message_later(
    :subscriptions,
    I18n.t('notifications.discord.charge_bee.subscription_created',
           type: payload.fetch(:type),
           amount: payload.fetch(:amount),
           trial_ends: I18n.l(payload.fetch(:trial_ends)),
           automated_ticket_id: payload.fetch(:automated_ticket_id),
           user_email: payload.fetch(:user_email))
  )
end

ActiveSupport::Notifications.subscribe 'charge_bee.subscription_pause_error' do |_name, _start, _finish, _id, payload|
  Notifiers::Discord.send_message_later(
    :errors,
    I18n.t('notifications.discord.charge_bee.subscription_pause_error',
           message: payload.fetch(:message),
           automated_ticket_id: payload.fetch(:automated_ticket_id),
           user_email: payload.fetch(:user_email))
  )
end
