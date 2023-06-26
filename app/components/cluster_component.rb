# frozen_string_literal: true

class ClusterComponent < ViewComponent::Base
  def initialize(justify_content: nil, gap: nil)
    @justify_content = justify_content
    @gap = gap
  end
end
