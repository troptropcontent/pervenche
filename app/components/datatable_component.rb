# frozen_string_literal: true

class DatatableComponent < ViewComponent::Base
  def initialize(rows:, columns:)
    @rows = rows
    @columns = columns
  end

  def formated_rows
    @rows.map do |row|
      @columns.map do |column|
        row[column[:field]] || column[:format].call(row)
      end
    end
  end

  def headers
    @columns.map do |column|
      column[:header]
    end
  end
end
