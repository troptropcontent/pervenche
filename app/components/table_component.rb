# frozen_string_literal: true

class TableComponent < ViewComponent::Base
  class Column < T::Struct
    const :title, String
    const :attribute, Symbol
    const :format, T.nilable(T.any(Symbol, Proc))
  end
  class Cell < T::Struct
    const :content, T.nilable(T.untyped)
  end

  def initialize(columns:, rows:, header_translation_key: nil)
    @header_translation_key = header_translation_key
    @columns = build_columns(columns)
    @rows = build_rows(rows)
  end

  private

  def build_columns(columns)
    columns.map{|column|
      Column.new(
        title: @header_translation_key ? I18n.t("#{@header_translation_key}.#{column[:attribute]}") : column[:attribute].to_s, 
        attribute:  column[:attribute],
        format: column[:format]
      )
    }
  end

  def build_rows(rows)
    rows.map{ |row| 
      @columns.map { |column| 
        value = row[column.attribute]
        value = format_value(column.format, value)
        Cell.new(content: value)
      }
    }
  end

  def format_value(format, value)
    return value if format.nil? || value.nil?
    return format_with_proc(value, format) if format.is_a?(Proc)
    return format_as_date(value) if format == :date
    format_as_text(value)
  end

  def format_as_text(value)
    value.to_s
  end

  def format_as_date(value)
    I18n.l(value, format: :short)
  end

  def format_with_proc(value, proc)
    proc.call(value)
  end
end
