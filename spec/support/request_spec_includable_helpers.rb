# frozen_string_literal: true

module RequestSpecIncludableHelpers
  def run(example)
    code = example.metadata[:code]
    message = example.metadata[:message]
    method = example.metadata[:method]
    path = example.metadata[:path]
    rehydrated_path = path.gsub(/:[a-z_]+/) { |match| send(match[1..]).to_s }
    params ||= {}
    send(method, rehydrated_path, params:)
    expect(response.code).to eq(code)
    expect(response.message).to eq(message)
  end
end
