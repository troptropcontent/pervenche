# frozen_string_literal: true
# typed: strict

module ApEmail
  class DeliveryMethod
    extend T::Sig
    sig { params(settings: T.untyped).void }
    def initialize(settings)
      @settings = settings
    end

    sig { params(mail: Mail::Message).void }
    def deliver!(mail)
      from = mail.from.first
      to = mail.to
      template_id = mail[:template_id].unparsed_value
      template_data = mail['template-data'].unparsed_value

      ApEmail.deliver(from:, to:, template_id:, template_data:)
    end
  end
end
