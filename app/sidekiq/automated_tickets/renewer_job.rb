# typed: true
# frozen_string_literal: true

class AutomatedTickets::RenewerJob
  extend T::Sig
  include Sidekiq::Job

  sig do
    params(automated_ticket_id: Integer, zipcode: String, last_request_on: T.nilable(DateTime)).returns(T.untyped)
  end
  def perform(automated_ticket_id, zipcode, last_request_on)
    AutomatedTicket::Renewer.call(automated_ticket_id:, zipcode:, last_request_on:)
  end
end
