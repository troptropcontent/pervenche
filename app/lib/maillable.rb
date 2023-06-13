# frozen_string_literal: true
# typed: strict

module Maillable
  extend T::Sig
  @mailing_client = T.let(:unassigned, Symbol)
  @default_from = T.let('unassigned', String)
  class MaillableError < StandardError; end
  class << self
    extend T::Sig

    sig { returns(Symbol) }
    attr_accessor :mailing_client

    sig { returns(String) }
    attr_accessor :default_from

    # rubocop:disable Naming/BlockForwarding, Lint/UnusedMethodArgument
    sig { params(blk: T.proc.params(arg0: T.class_of(Maillable)).void).void }
    def configure(&blk)
      yield self
    end
    # rubocop:enable Naming/BlockForwarding, Lint/UnusedMethodArgument

    sig { params(to: String, template_id: String, template_data: T::Hash[String, T.untyped]).returns(T.untyped) }
    def send_email(to:, template_id:, template_data:)
      client.send_email(to:, template_id:, template_data:)
    end

    private

    sig { returns(T.class_of(Clients::Sendgrid)) }
    def client
      return Clients::Sendgrid if mailing_client == :sendgrid

      raise MaillableError, "#{mailing_client} client is not supported"
    end
  end

  sig { params(to: String, template_id: String, template_data: T::Hash[String, T.untyped]).void }
  def deliver_later(to:, template_id:, template_data:)
    Maillable::EmailJob.perform_async(to, template_id, template_data)
  end

  sig { params(to: String, template_id: String, template_data: T::Hash[String, T.untyped]).void }
  def deliver_now(to:, template_id:, template_data:)
    Maillable::EmailJob.new.perform(to, template_id, template_data)
  end
end
