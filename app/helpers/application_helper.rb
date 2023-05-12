# frozen_string_literal: true
# typed: true

module ApplicationHelper
  def empty_inputs_for(form, record_class, field)
    input_name = "#{form.object_name}[#{field}]"
    array_field_column = record_class.columns_hash[field.to_s].sql_type_metadata.sql_type.end_with?('[]')
    input_name += '[]' if array_field_column
    form.input(field, input_html: { name: input_name, value: nil }, as: :hidden)
  end
end
