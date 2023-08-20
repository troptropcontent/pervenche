# frozen_string_literal: true

module RequestSpecIncludableHelpers
  def run(example)
    code = example.metadata[:code]
    message = example.metadata[:message]
    method = example.metadata[:method]
    path = example.metadata[:path]
    body = request_body if respond_to?(:request_body)
    params = example.metadata[:params] || body || {}
    rehydrated_path = path.gsub(/:[a-z_]+/) { |match| send(match[1..]).to_s }
    send(method, rehydrated_path, params:)
    expect(response.code).to eq(code)
    expect(response.message).to eq(message)
  end
end
