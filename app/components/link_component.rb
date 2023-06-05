# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(path:, action:, icon:, text:)
    @path = path
    @action = action
    @icon = icon
    @text = text
  end

end
