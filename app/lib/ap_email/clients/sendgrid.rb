# frozen_string_literal: true
# typed: true

module ApEmail
  module Clients
    class Sendgrid
      include SendGrid
      extend T::Sig
      sig do
        params(
          from: String,
          to: T.any(String, T::Array[String]),
          template_id: String,
          template_data: T::Hash[String, T.untyped]
        )
          .void
      end
      def self.deliver(from:, to:, template_id:, template_data:)
        mail = build_email(from:, to:, template_id:, template_data:)
        sendgrid = SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid, :api_key))
        sendgrid.client.mail._('send').post(request_body: mail.to_json)
      end

      sig do
        params(
          from: String,
          to: T.any(String, T::Array[String]),
          template_id: String,
          template_data: T::Hash[String, T.untyped]
        )
          .returns(Mail)
      end
      def self.build_email(from:, to:, template_id:, template_data:)
        mail = Mail.new
        mail.from = Email.new(email: from)
        personalization = Personalization.new
        tos = to.is_a?(Array) ? to : [to]
        tos.map { |recipient| personalization.add_to(Email.new(email: recipient)) }
        personalization.add_bcc(Email.new(email: 'contact@pervenche.eu'))
        template_data = JSON.parse(template_data) if template_data.is_a?(String)
        personalization.add_dynamic_template_data(template_data)
        mail.add_personalization(personalization)
        mail.template_id = template_id
        mail
      end
    end
  end
end
