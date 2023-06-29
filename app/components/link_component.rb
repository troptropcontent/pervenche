# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(link: nil, **args)
    if link
      @path = link.path
      @action = link.action
      @icon = link.icon
      @text = link.text
      @color = link.color
    else
      @path = args[:path]
      @action = args[:action]
      @icon = args[:icon]
      @text = args[:text]
      @color = args[:color]
    end
  end
end
