# frozen_string_literal: true

module Faraday
  class Response
    class NotifyErrors < Middleware
      def on_complete(env)
        return if env.status < 400

        payload = {
          method: env.method.to_s.upcase,
          url: env.url.to_s,
          status: env.status,
          body: env.body
        }

        ActiveSupport::Notifications.instrument 'faraday.errors', payload
      end
    end
  end
end
