# typed: strict
# frozen_string_literal: true

ActiveSupport::Notifications.subscribe 'users.created' do |_name, _start, _finish, _id, payload|
  Notifiers::Discord.send_message(
    :new_users,
    I18n.t('notifications.discord.new_user', email: payload.fetch('email'))
  )
end
