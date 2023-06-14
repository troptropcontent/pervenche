# frozen_string_literal: true
# typed: true

require Rails.root.join('app/lib/ap_email')

ApEmail.configure do |config|
  config.email_service = :sendgrid
end

# if you want to set the delivery_method inside the env conf like
# config.action_mailer.delivery_method = :ap_email
# uncomment the bellow line
# ActionMailer::Base.add_delivery_method :ap_email, ApEmail::DeliveryMethod
