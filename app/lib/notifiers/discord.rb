module Notifiers
  class Discord
    class << self
      def errors(content)
        HttpClient.post(
          url: Rails.application.credentials.notifiers.discord.webhooks_url.errors,
          body: URI.encode_www_form({ content: content_with_env_prefix(content) })
        ).body
      end

      private

      def content_with_env_prefix(content)
        "Pervenche (#{Rails.env})\n\n#{content}"
      end
    end
  end
end
