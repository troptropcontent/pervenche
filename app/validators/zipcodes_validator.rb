class ZipcodesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, values)
    Array(values).each do |value|
      # validates the format of the each zipcode
      next if value =~ /^[0-9]+/

      message = I18n.t('activerecord.errors.models.automated_ticket.attributes.zipcodes.invalid', value:)
      record.errors.add attribute, message
    end
    # validates that the zipcodes returns at least one rate_option, only in production
    return unless ENV['PERVENCHE_VALIDATES_ZIPCODES']

    rate_options = record.service.rate_options(values, record.license_plate)
    message = I18n.t('activerecord.errors.models.automated_ticket.attributes.zipcodes.not_possible',
                     count: values.count)
    record.errors.add attribute, message unless rate_options.length >= 1
  end
end