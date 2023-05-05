# frozen_string_literal: true

RSpec.shared_context 'with an environment variable' do |env_name, env_value|
  before(:context) do
    ENV[env_name] = env_value
  end
  after(:context) do
    ENV.delete(env_name)
  end
end
