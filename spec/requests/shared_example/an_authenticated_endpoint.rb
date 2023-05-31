# frozen_string_literal: true

RSpec.shared_examples 'An authenticated endpoint' do
  response '302', 'Found' do
    it 'redirect to the log in page' do |example|
      run(example)
      expect(response).to redirect_to('/users/sign_in')
    end
  end
end
