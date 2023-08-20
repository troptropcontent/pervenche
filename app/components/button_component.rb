# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(path:, method:, text: nil, color: 'primary', data: {}, params: {})
    super()
    @color = color
    @path = path
    @method = method
    @text = text
    @params = params
    @data = data
  end

  def classes
    "btn btn--#{@color}"
  end
end
