class ApplicationMailer < ActionMailer::Base
  default from: (ENV['PERVENCHE_MAILER_DEFAULT_FROM'] || "contact+#{Rails.env}@pervenche.eu"),
          delivery_method: ApEmail::DeliveryMethod,
          body: ''

  def build_template_data(**template_data_fields)
    template_data_fields.deep_stringify_keys
  end
end
