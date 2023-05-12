# frozen_string_literal: true

class SanitizedParams < Actor
  input :permited_params
  output :sanitized_params
  def call
    self.sanitized_params = permited_params.transform_values do |value|
      if value.blank?
        nil
      elsif value.is_a?(Array)
        value.compact_blank
      else
        value
      end
    end
  end
end
