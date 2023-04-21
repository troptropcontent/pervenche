# typed: strict
# frozen_string_literal: true

module Notifiers
  class Discord
    class << self
      extend T::Sig

      sig { params(channel: Symbol, content: String).void }
      def send_message(channel, content)
        return unless ENV.fetch('PERVENCHE_DISCORD_NOTIFICATION', nil)

        url = Rails.application.credentials.notifiers.discord.webhooks_url.fetch(channel)
        Http::Client.post(
          url:,
          body: { content: content_with_env_prefix(content) }
        )
      end

      private

      sig { params(content: String).returns(String) }
      def content_with_env_prefix(content)
        "Pervenche (#{Rails.env})\n\n#{content}"
      end
    end
  end
end
