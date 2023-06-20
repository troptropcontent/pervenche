# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(link: nil, **args)
    if link
      @path = link.path
      @action = link.action
      @icon = link.icon
      @text = link.text
    else
      @path = args[:path]
      @action = args[:action]
      @icon = args[:icon]
      @text = args[:text]
    end
  end
end
