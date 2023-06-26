# frozen_string_literal: true

RSpec.shared_examples 'An operationnal endpoint' do
  response '302', 'Found' do
    before { sign_in user }
    it 'redirects to onboarding page' do |example|
      run(example)
      expect(response).to redirect_to('/onboarding')
    end
  end
end
