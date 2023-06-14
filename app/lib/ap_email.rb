# frozen_string_literal: true
# typed: strict

require Rails.root.join('app/lib/ap_email/delivery_method')
module ApEmail
  extend T::Sig
  @email_service = T.let(:unassigned, Symbol)
  class Error < StandardError; end
  class << self
    extend T::Sig
    sig { returns(Symbol) }
    attr_accessor :email_service

    # rubocop:disable Naming/BlockForwarding, Lint/UnusedMethodArgument
    sig { params(blk: T.proc.params(arg0: T.class_of(ApEmail)).void).void }
    def configure(&blk)
      yield self
    end
    # rubocop:enable Naming/BlockForwarding, Lint/UnusedMethodArgument

    sig { returns(T.class_of(ApEmail::Clients::Sendgrid)) }
    def client
      return ApEmail::Clients::Sendgrid if email_service == :sendgrid

      raise Error, "Unknown service #{email_service}"
    end

    sig do
      params(
        from: String,
        to: T.any(String, T::Array[String]),
        template_id: String,
        template_data: T::Hash[String, T.untyped]
      )
        .void
    end
    def deliver(from:, to:, template_id:, template_data:)
      client.deliver(from:, to:, template_id:, template_data:)
    end
  end
end
