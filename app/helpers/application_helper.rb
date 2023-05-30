# frozen_string_literal: true
# typed: true

module ApplicationHelper
  extend T::Sig
  def empty_inputs_for(form, record_class, field)
    input_name = "#{form.object_name}[#{field}]"
    array_field_column = record_class.columns_hash[field.to_s].sql_type_metadata.sql_type.end_with?('[]')
    input_name += '[]' if array_field_column
    form.input(field, input_html: { name: input_name, value: nil }, as: :hidden)
  end

  sig { params(money_object: Money, period: String).returns(String) }
  def subscription_with_period(money_object, period)
    currency_symbol = money_object.currency.symbol
    amount = money_object.amount
    period = t("datetime.prompts.#{period}")
    "#{amount} #{currency_symbol} / #{period}"
  end
end
