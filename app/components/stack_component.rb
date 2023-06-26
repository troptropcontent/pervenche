# frozen_string_literal: true

class StackComponent < ViewComponent::Base
  def initialize(gap: nil, justify_content: nil, wrapper_class: nil)
    @gap = gap
    @justify_content = justify_content
    @wrapper_class = wrapper_class
  end
end
