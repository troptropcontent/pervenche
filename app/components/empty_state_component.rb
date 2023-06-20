# frozen_string_literal: true

class EmptyStateComponent < ViewComponent::Base
  def initialize(wrapper_class: nil)
    @wrapper_class = wrapper_class
  end
end
