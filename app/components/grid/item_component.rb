# frozen_string_literal: true

class Grid::ItemComponent < ViewComponent::Base
  def initialize(column: nil, row: nil, full: false)
    @column_class = build_column_class(column)
    @row_class = build_row_class(row)
    @full_class = 'grid__item--full' if full
  end

  private

  def build_column_class(column)
    # to be implemented
  end

  def build_row_class(row)
    # to be implemented
  end
end
