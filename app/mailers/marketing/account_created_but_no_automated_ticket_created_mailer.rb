# frozen_string_literal: true
# typed: strict

module Marketing
  class AccountCreatedButNoAutomatedTicketCreatedMailer < TemplateMailer
    extend T::Sig
    template_id 'd-82716949fa6a46e7992c36b5939743f1'

    sig do
      params(
        to: T.any(String, T::Array[String]),
        account_created_at: T.any(String, DateTime)
      )
        .returns(T.untyped)
    end
    def template(to:, account_created_at:)
      template_email(to:, template_data: build_template_data(account_created_at:))
    end
  end
end
