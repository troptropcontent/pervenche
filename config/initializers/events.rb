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
