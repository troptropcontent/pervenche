# frozen_string_literal: true

class HeaderComponent < ViewComponent::Base
  def initialize(title:, icon: nil, subtitle: nil, back_link: nil, menu_links: nil)
    @title = title
    @icon = icon
    @subtitle = subtitle
    @back_link = back_link
    @menu_links = menu_links
  end
end
