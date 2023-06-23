# frozen_string_literal: true

class TextComponent < ViewComponent::Base
  def initialize(color: nil)
    @color = color
  end
end
