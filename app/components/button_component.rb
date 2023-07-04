# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(path:, method:, text: nil, color: 'primary')
    @color = color
    @path = path
    @method = method
    @text = text
  end

  def classes
    "btn btn--#{@color}"
  end
end
