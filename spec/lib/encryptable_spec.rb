require 'rails_helper'

RSpec.describe Encryptable do
  include Encryptable

  describe '#hash_secret' do
    context 'deterministic' do
      it 'always returns the same hash' do
        expect(hash_secret('a_value')).to eq(hash_secret('a_value'))
      end
    end
    context 'non deterministic' do
      it 'does not return the same hash' do
        expect(hash_secret('a_value', deterministic: false)).not_to eq(hash_secret('a_value', deterministic: false))
      end
    end
  end
end
