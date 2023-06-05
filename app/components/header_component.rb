# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(title:, subtitle:, back_link:, menu_links:)
    @title = title
    @subtitle = subtitle
    @back_link = back_link
    @menu_links = menu_links
  end

end
