# frozen_string_literal: true
# typed: strict

module Billable
  class << self
    extend T::Sig

    sig { returns(T.nilable(Symbol)) }
    attr_accessor :billing_client

    # rubocop:disable Naming/BlockForwarding, Lint/UnusedMethodArgument
    sig { params(blk: T.proc.params(arg0: T.class_of(Billable)).void).void }
    def configure(&blk)
      yield self
    end
    # rubocop:enable Naming/BlockForwarding, Lint/UnusedMethodArgument
  end
end
