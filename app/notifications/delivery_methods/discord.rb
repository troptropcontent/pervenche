# frozen_string_literal: true

class DeliveryMethods::Discord < Noticed::DeliveryMethods::Base
  option :channel
  def deliver
    Notifiers::Discord.send_message(options[:channel], message)
  end

  private

  def message
    notification.t('.discord_message', **params) || notification.send(options[:format])
  end
end
