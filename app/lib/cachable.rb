# typed: true
# frozen_string_literal: true

module Cachable
  extend T::Sig
  include Encryptable
  sig do
    params(cache_key: String, expires_in: Integer, encrypted_key: T::Boolean, block: T.proc.void).returns(T.untyped)
  end
  def cached(cache_key:, expires_in:, encrypted_key: true, &block)
    cache_key = hash_secret(cache_key) if encrypted_key
    Rails.cache.fetch(cache_key, expires_in:, &block)
  end
end
