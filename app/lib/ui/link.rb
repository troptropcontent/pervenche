# frozen_string_literal: true
# typed: strict

module Ui
  class Link < T::Struct
    const :action, Symbol, default: :get
    const :path, String
    const :icon, T.nilable(String)
    const :text, T.nilable(String)
    const :color, T.nilable(String)
  end
end
