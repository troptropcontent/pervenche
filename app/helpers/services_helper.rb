module ServicesHelper
  def kinds(disabled: [])
    Service.kinds.each_with_object([]) do |(key, _value), memo|
      base_data = [t("models.service.attributes.kind.enum.#{key}"), key]
      options = { disabled: true } if disabled.include?(key.to_sym)
      memo << [*base_data, options].compact
    end
  end
end
