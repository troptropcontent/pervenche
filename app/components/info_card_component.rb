# frozen_string_literal: true

class InfoCardComponent < ViewComponent::Base
  def initialize(color:, center: false, wrapper_class: nil, title: nil, sub_title: nil)
    @color = color
    @center = center
    @wrapper_class = wrapper_class
    @title = title
    @sub_title = sub_title
  end
end
