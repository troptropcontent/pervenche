# frozen_string_literal: true

module Billing
  module Customerable
    extend ActiveSupport::Concern
    included do
      delegate :subscriptions, to: :customer
    end

    def customer
      @customer ||= Billing::Customer.find(self[billing_client_id_attribute])
    end

    def create_customer
      # to be implemented
      # something like
      # new_customer = Billing::Customer.create
      # update!(self[billing_client_id_attribute] => new_customer.client_id)
    end
  end
end
