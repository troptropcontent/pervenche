# frozen_string_literal: true

module Billing
  module Errors
    class UnprocessableEntity < StandardError; end
    class NotFound < StandardError; end
  end
end
