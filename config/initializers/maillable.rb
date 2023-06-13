# frozen_string_literal: true
# typed: true

require Rails.root.join('app/lib/maillable')

Maillable.configure do |config|
  config.mailing_client = :sendgrid
  config.default_from = ENV['PERVENCHE_MALLABLE_DEFAULT_FROM'] || "contact+#{Rails.env}@pervenche.eu"
end
