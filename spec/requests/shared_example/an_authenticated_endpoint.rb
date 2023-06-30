# frozen_string_literal: true

RSpec.shared_examples 'An authenticated endpoint' do
  if example.metadata[:path].to_s.match(/.*(\.(.*))/) && example.metadata[:path].to_s.match(/.*(\.(.*))/)[1] != '.html'
    response '401', 'Unauthorized' do
      it 'returns a 401 Unauthorised' do |example|
        run(example)
      end
    end
  else
    response '302', 'Found' do
      it 'redirect to the log in page' do |example|
        run(example)
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end
end
