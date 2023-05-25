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

  def response(code, message, &)
    describe("#{code} #{message}", code:, message:, &)
  end

  def params(params)
    let(:params) { params }
  end
end
