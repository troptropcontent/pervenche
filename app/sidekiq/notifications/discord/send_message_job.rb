# typed: strict
# frozen_string_literal: true

class Notifications::Discord::SendMessageJob
  extend T::Sig
  include Sidekiq::Job
  sidekiq_options queue: :low

  sig { params(channel: String, content: String).void }
  def perform(channel, content)
    Notifiers::Discord.send_message(channel.to_sym, content)
  end
end
