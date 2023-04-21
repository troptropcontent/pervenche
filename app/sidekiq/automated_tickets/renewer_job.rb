# typed: strict
# frozen_string_literal: true

class AutomatedTickets::RenewerJob
  extend T::Sig
  include Sidekiq::Job

  sig { params(automated_ticket_id: Integer, zipcode: String).returns(T.untyped) }
  def perform(automated_ticket_id, zipcode)
    AutomatedTicket::Renewer.call(automated_ticket_id:, zipcode:)
  end
end
