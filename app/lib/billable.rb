# frozen_string_literal: true
# typed: strict

module Billable
  class << self
    extend T::Sig

    sig { returns(T.nilable(Symbol)) }
    attr_accessor :billing_client

    sig { returns(T.nilable(T::Hash[Symbol, T.untyped])) }
    attr_accessor :billing_client_configuration

    sig { returns(T.nilable(String)) }
    attr_accessor :webhook_token

    # rubocop:disable Naming/BlockForwarding, Lint/UnusedMethodArgument
    sig { params(blk: T.proc.params(arg0: T.class_of(Billable)).void).void }
    def configure(&blk)
      yield self
    end
    # rubocop:enable Naming/BlockForwarding, Lint/UnusedMethodArgument
  end
end
