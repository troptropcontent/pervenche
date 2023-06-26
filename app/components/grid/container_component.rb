# frozen_string_literal: true

class Grid::ContainerComponent < ViewComponent::Base
  def initialize(gap:, columns:)
    @column_class = find_column_class(columns)
    @gap_class = find_gap_class(gap)
  end

  private

  def find_column_class(column)
    return 'grid--2-columns' if column == 2
    return 'grid--3-columns' if column == 3
  end

  def find_gap_class(gap)
    return 'grid--gap-s' if gap == 's'
    return 'grid--gap-m' if gap == 'm'
    return 'grid--gap-l' if gap == 'l'
  end
end
