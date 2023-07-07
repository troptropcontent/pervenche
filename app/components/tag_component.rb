# frozen_string_literal: true

class TagComponent < ViewComponent::Base
  def initialize(text: nil, color: 'muted')
    @color = color
    @text = text
  end
end
