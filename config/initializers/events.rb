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

ActiveSupport::Notifications.subscribe 'charge_bee.subscription_resume_error' do |_name, _start, _finish, _id, payload|
  Notifiers::Discord.send_message_later(
    :errors,
    I18n.t('notifications.discord.charge_bee.subscription_resume_error',
           message: payload.fetch(:message),
           automated_ticket_id: payload.fetch(:automated_ticket_id),
           user_email: payload.fetch(:user_email))
  )
end

ActiveSupport::Notifications.monotonic_subscribe 'job.automated_tickets.renewer_job.main' do |name, started, finished, _unique_id, data|
  log_data_hash = {
    jid: data[:jid],
    kind: 'custom_instrumentation',
    name:,
    started:,
    finished:,
    elapsed: (finished - started),
    automated_ticket_id: data[:automated_ticket_id],
    zipcode: data[:zipcode]
  }
  log_data_json = JSON.generate(log_data_hash)
  Rails.logger.info log_data_json
end

ActiveSupport::Notifications.monotonic_subscribe 'job.automated_tickets.renewer_job.find_or_save_running_ticket_actor' do |name, started, finished, _unique_id, data|
  log_data_hash = {
    jid: data[:jid],
    kind: 'custom_instrumentation',
    name:,
    started:,
    finished:,
    elapsed: (finished - started)
  }
  log_data_json = JSON.generate(log_data_hash)
  Rails.logger.info log_data_json
end

ActiveSupport::Notifications.monotonic_subscribe 'job.automated_tickets.renewer_job.find_payment_method_actor' do |name, started, finished, _unique_id, data|
  log_data_hash = {
    jid: data[:jid],
    kind: 'custom_instrumentation',
    name:,
    started:,
    finished:,
    elapsed: (finished - started)
  }
  log_data_json = JSON.generate(log_data_hash)
  Rails.logger.info log_data_json
end

ActiveSupport::Notifications.monotonic_subscribe 'job.automated_tickets.renewer_job.find_time_unit_and_quantity_actor' do |name, started, finished, _unique_id, data|
  log_data_hash = {
    jid: data[:jid],
    kind: 'custom_instrumentation',
    name:,
    started:,
    finished:,
    elapsed: (finished - started)
  }
  log_data_json = JSON.generate(log_data_hash)
  Rails.logger.info log_data_json
end

ActiveSupport::Notifications.monotonic_subscribe 'job.automated_tickets.renewer_job.request_new_ticket_actor' do |name, started, finished, _unique_id, data|
  log_data_hash = {
    jid: data[:jid],
    kind: 'custom_instrumentation',
    name:,
    started:,
    finished:,
    elapsed: (finished - started)
  }
  log_data_json = JSON.generate(log_data_hash)
  Rails.logger.info log_data_json
end
