# typed: true
# frozen_string_literal: true

class HttpClient
  # TO DO ADD TYPE HERE
  class JsonFormater < Faraday::Logging::Formatter
    def request(env); end

    def response(env)
      # Build a custom message using `env`
      info('Request') do
        json = JSON.generate({ source: :http_client,
                               status: env.status,
                               url: env.url,
                               method: env.method,
                               request: { body: env.request_body, headers: env.request_headers },
                               headers: env.response_headers,
                               body: env.response_body })

        json.gsub(/(username=|password=)([^&]+)/, '\1[REMOVED]')
      end
    end

    def exception(_exc); end
  end
  extend T::Sig
  sig do
    params(url: String,
           headers: T.nilable(T::Hash[T.untyped, T.untyped]),
           params: T.nilable(T.any(T::Hash[T.untyped, T.untyped], String)),
           token: T.nilable(String),
           use_proxy: T.nilable(T::Boolean))
      .returns(Faraday::Response)
  end
  def self.get(url:, headers: nil, params: nil, token: nil, use_proxy: false)
    connection(url:, headers:, token:).get do |request|
      request.params = params if params
    end
  end

  sig do
    params(url: String,
           body: T.nilable(T.any(T::Hash[T.untyped, T.untyped], String)),
           headers: T.nilable(T::Hash[T.untyped, T.untyped]),
           token: T.nilable(String),
           use_proxy: T.nilable(T::Boolean))
      .returns(Faraday::Response)
  end
  def self.post(url:, body: nil, headers: nil, token: nil, use_proxy: false)
    connection(url:, headers:, token:).post do |request|
      request.body =  URI.encode_www_form(body) if body.is_a? Hash
      request.body =  body if body.is_a? String
    end
  end

  sig do
    params(url: String,
           headers: T.nilable(T::Hash[T.untyped, T.untyped]),
           token: T.nilable(String),
           use_proxy: T.nilable(T::Boolean))
      .returns(Faraday::Connection)
  end
  def self.connection(url:, headers:, token: nil, use_proxy: false)
    Faraday.new(
      url:,
      headers:,
      proxy: (ENV.fetch('PERVENCHE_HTTP_PROXY') if use_proxy)
    ) do |conn|
      conn.response :json
      conn.request(:authorization, 'Bearer', token) if token
      conn.response :raise_error
      conn.response :logger, Rails.logger, { formatter: JsonFormater }
    end
  end
end
