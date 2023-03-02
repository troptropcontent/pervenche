module ServicesHelper
  def kinds(disabled: [])
    Service.kinds.each_with_object([]) do |(key, _value), memo|

      base_data = [Service.human_enum_name(:kinds, key), key]
      options = { disabled: true } if disabled.include?(key.to_sym)
      memo << [*base_data, options].compact
    end
  end
end
