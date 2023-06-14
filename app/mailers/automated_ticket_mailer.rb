# frozen_string_literal: true
# typed: strict

class AutomatedTicketMailer < ApplicationMailer
  extend T::Sig
  sig do
    params(
      to: T.any(String, T::Array[String]),
      license_plate: String,
      update_payment_method_url: String
    )
      .returns(Mail::Message)
  end
  def trial_period_ends_soon(to:, license_plate:, update_payment_method_url:)
    mail(to:,
         template_id: 'd-854b722cd1c1467d9b59fc5b68aa8618',
         template_data: build_template_data(license_plate:, update_payment_method_url:))
  end
end
