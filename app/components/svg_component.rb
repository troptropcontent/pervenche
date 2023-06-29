# frozen_string_literal: true

class SvgComponent < ViewComponent::Base
  def initialize(name:, color: nil)
    @color = color
    @name = name
  end

end
