# frozen_string_literal: true

module RequestSpecExtendableHelpers
  def path(path, &)
    describe(path, path:, &)
  end

  def get(description, &)
    describe(description, method: :get, &)
  end

  def put(description, &)
    describe(description, method: :put, &)
  end

  def post(description, &)
    describe(description, method: :post, &)
  end

  def response(code, message, &)
    describe("#{code} #{message}", code:, message:, &)
  end

  def params(&)
    metadata[:params] = yield
  end
end
