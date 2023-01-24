module ServicesHelper
  def kinds
    Service.kinds.each_with_object([]) do |(key, _value), memo|
      memo << [t("models.service.attributes.kind.enum.#{key}"), key]
    end
  end
end
