# frozen_string_literal: true
# typed: strict

class TemplateMailer < ApplicationMailer
  default from: (ENV['PERVENCHE_MAILER_DEFAULT_FROM'] || "contact+#{Rails.env}@pervenche.eu"),
          delivery_method: ApEmail::DeliveryMethod,
          body: ''

  def self.template_id(template_id = nil)
    @template_id ||= template_id
  end

  def build_template_data(template_data_fields)
    template_data_fields.deep_stringify_keys
  end

  def template_email(to:, template_data: {})
    mail(to:,
         template_id: self.class.template_id,
         template_data: build_template_data(template_data))
  end

  def action_name
    self.class.name
  end
end
