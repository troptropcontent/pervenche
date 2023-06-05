# frozen_string_literal: true
# typed: true

class HeaderComponent < ViewComponent::Base
  extend T::Sig
  sig do
    params(
      title: String,
      icon: T.nilable(String),
      subtitle: T.nilable(String),
      back_link: T.nilable(Ui::Link),
      menu_links: T.nilable(T::Array[Ui::Link])
    )
      .void
  end
  def initialize(title:, icon: nil, subtitle: nil, back_link: nil, menu_links: [])
    @title = title
    @icon = icon
    @subtitle = subtitle
    @back_link = back_link
    @menu_links = menu_links
  end
end
