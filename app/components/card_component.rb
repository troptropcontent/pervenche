# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(color: nil, padding: nil)
    @padding = padding
    @color = color
  end
end
