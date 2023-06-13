# frozen_string_literal: true
# typed: strict

module Maillable
  module Clients
    module Sendgrid
      class << self
        include SendGrid
        extend T::Sig
        sig { params(to: String, subject: String, content: String).void }
        def send_email(to:, subject:, content:)
          from = Email.new(email: Maillable.default_from)
          to = Email.new(email: to)
          content = Content.new(type: 'text/plain', value: content)
          mail = Mail.new(from, subject, to, content)

          deliver(mail)
        end

        sig { params(to: String, template_id: String, template_data: T::Hash[String, T.untyped]).void }
        def send_template_email(to:, template_id:, template_data:)
          mail = Mail.new
          mail.from = Email.new(email: Maillable.default_from)
          personalization = Personalization.new
          personalization.add_to(Email.new(email: to))
          personalization.add_dynamic_template_data(template_data)
          mail.add_personalization(personalization)
          mail.template_id = template_id

          deliver(mail)
        end

        private

        sig { params(mail: Mail).void }
        def deliver(mail)
          sendgrid = SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid, :api_key))
          sendgrid.client.mail._('send').post(request_body: mail.to_json)
        end
      end
    end
  end
end
