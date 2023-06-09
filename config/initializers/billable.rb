# frozen_string_literal: true
# typed: true

require Rails.root.join('app/lib/billable')

Billable.configure do |config|
  config.billing_client = :charge_bee
end
