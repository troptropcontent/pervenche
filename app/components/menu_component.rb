# frozen_string_literal: true

class MenuComponent < ViewComponent::Base
  def initialize(links: [])
    @links = links
  end
end
