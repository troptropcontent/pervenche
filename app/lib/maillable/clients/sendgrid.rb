# frozen_string_literal: true
# typed: strict

module Maillable
  module Clients
    module Sendgrid
      class << self
        include SendGrid
        extend T::Sig

        sig { params(to: String, template_id: String, template_data: T::Hash[String, T.untyped]).void }
        def send_email(to:, template_id:, template_data:)
          mail = build_email(to:, template_id:, template_data:)
          deliver(mail)
        end

        private

        sig { params(to: String, template_id: String, template_data: T::Hash[String, T.untyped]).returns(Mail) }
        def build_email(to:, template_id:, template_data:)
          mail = Mail.new
          mail.from = Email.new(email: Maillable.default_from)
          personalization = Personalization.new
          personalization.add_to(Email.new(email: to))
          personalization.add_dynamic_template_data(template_data)
          mail.add_personalization(personalization)
          mail.template_id = template_id
          mail
        end

        sig { params(mail: Mail).void }
        def deliver(mail)
          sendgrid = SendGrid::API.new(api_key: Rails.application.credentials.dig(:sendgrid, :api_key))
          sendgrid.client.mail._('send').post(request_body: mail.to_json)
        end
      end
    end
  end
end
