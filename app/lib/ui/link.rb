# frozen_string_literal: true
# typed: strict

module Ui
  class Link < T::Struct
    const :action, Symbol
    const :path, String
  end
end
