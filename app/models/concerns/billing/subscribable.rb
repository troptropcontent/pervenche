# frozen_string_literal: true

module Billing
  module Subscribable
    extend ActiveSupport::Concern

    def subscription
      @subscription ||= Billing::Subscription.find(self[billing_client_id_attribute])
    end
  end
end
