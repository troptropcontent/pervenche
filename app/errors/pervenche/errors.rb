# frozen_string_literal: true

module Pervenche
  module Errors
    # Non-bug exceptions
    class InvalidState < StandardError; end
    class UnprocessableEntity < StandardError; end
    class NotFound < StandardError; end
  end
end
