# frozen_string_literal: true

class TextComponent < ViewComponent::Base
  def initialize(color: nil, text: nil)
    @color = color
    @text = text
  end
end
