class DeliveryMethods::TemplateEmail < Noticed::DeliveryMethods::Base
  def deliver
    Emails::Templates::VehicleAtRisk.new(
      to: recipient.email,
      template_data: {
        license_plate: params[:license_plate],
        zipcode: params[:zipcode]
      }
    ).deliver_now
  end
end
