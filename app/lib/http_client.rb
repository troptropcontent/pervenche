# typed: strict
# frozen_string_literal: true

class HttpClient
  extend T::Sig
  sig do
    params(url: String,
           headers: T.nilable(T::Hash[T.untyped, T.untyped]),
           params: T.nilable(T.any(T::Hash[T.untyped, T.untyped], String)),
           token: T.nilable(String))
      .returns(Faraday::Response)
  end
  def self.get(url:, headers: nil, params: nil, token: nil)
    connection(url:, headers:, token:).get do |request|
      request.params = params if params
    end
  end

  sig do
    params(url: String,
           body: T.nilable(T.any(T::Hash[T.untyped, T.untyped], String)),
           headers: T.nilable(T::Hash[T.untyped, T.untyped]),
           token: T.nilable(String))
      .returns(Faraday::Response)
  end
  def self.post(url:, body: nil, headers: nil, token: nil)
    connection(url:, headers:, token:).post do |request|
      request.body = body if body
    end
  end

  sig do
    params(url: String,
           headers: T.nilable(T::Hash[T.untyped, T.untyped]),
           token: T.nilable(String))
      .returns(Faraday::Connection)
  end
  def self.connection(url:, headers:, token: nil)
    Faraday.new(
      url:,
      headers:,
      proxy: ENV.fetch('PERVENCHE_HTTP_PROXY', nil)
    ) do |conn|
      conn.response :json
      conn.request(:authorization, 'Bearer', token) if token
      conn.response :raise_error
      conn.response :logger, nil, { headers: false, bodies: true } do |logger|
        logger.filter(/(username=|password=)([^&]+)/, '\1[REMOVED]')
      end
    end
  end
end
