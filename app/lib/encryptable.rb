# typed: strict
# frozen_string_literal: true

module Encryptable
  extend T::Sig

  sig { params(value: T.untyped, deterministic: T.nilable(T::Boolean)).returns(String) }
  def hash_secret(value, deterministic: true)
    secondary_deterministic_key = Rails.application.credentials.active_record_encryption.secondary_deterministic_key
    salt = deterministic ? secondary_deterministic_key : BCrypt::Engine.generate_salt
    BCrypt::Engine.hash_secret(value, salt)
  end
end
