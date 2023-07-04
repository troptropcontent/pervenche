# frozen_string_literal: true
# typed: strict

class TemplateMailer < ApplicationMailer
  default from: (ENV['PERVENCHE_MAILER_DEFAULT_FROM'] || "contact+#{Rails.env}@pervenche.eu"),
          delivery_method: ApEmail::DeliveryMethod,
          body: ''

  def notify
    @to = params[:to]
    @template_id = params[:template_id]
    @template_data = params[:template_data]
    mail(to: @to,
         template_id: @template_id,
         template_data: build_template_data(@template_data))
  end

  private

  def build_template_data(template_data)
    template_data.deep_stringify_keys
  end
end
