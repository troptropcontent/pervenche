# frozen_string_literal: true

class TitleComponent < ViewComponent::Base
  def initialize(size: nil, color: nil)
    @size = find_html_size(size)
    @color = color
  end

  private

  def find_html_size(size)
    return 1 if size == 'xl'
    return 2 if size == 'l'
    return 3 if size == 'm'
    return 4 if size == 's'
    return 5 if size == 'xs'
    3
  end
end
