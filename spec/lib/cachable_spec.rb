require 'rails_helper'

RSpec.describe Cachable do
  include Cachable
  include Encryptable

  describe '#cached' do
    describe 'encrypted_key' do
      let(:unencrypted_key) { 'an/unencrypted/key' }
      context 'true' do
        let(:hashed_key) { hash_secret(unencrypted_key) }
        it 'uses an encrypted key' do
          expect(Rails.cache).to receive(:fetch).with(hashed_key, expires_in: 1200)
          cached cache_key: unencrypted_key, expires_in: 1200 do
            'something to cache'
          end
        end
      end
      context 'false' do
        it 'uses the key as is' do
          expect(Rails.cache).to receive(:fetch).with(unencrypted_key, expires_in: 1300)
          cached cache_key: unencrypted_key, expires_in: 1300, encrypted_key: false do
            'something to cache'
          end
        end
      end
    end
  end
end
