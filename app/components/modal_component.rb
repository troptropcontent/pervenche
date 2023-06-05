# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  def initialize(id:, title:, link_content:, link_class: nil, content_full_screen: false)
    @id = id
    @title = title
    @link_content = link_content
    @link_class = link_class
    @content_full_screen = content_full_screen
  end
end
