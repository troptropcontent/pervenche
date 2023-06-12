# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(link:)
    @path = link.path
    @action = link.action
    @icon = link.icon
    @text = link.text
  end
end
