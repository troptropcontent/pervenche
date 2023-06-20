# frozen_string_literal: true

class ListComponent < ViewComponent::Base
  def initialize(items: [], no_decoration: false)
    @items = items
    @no_decoration = no_decoration
  end
end
