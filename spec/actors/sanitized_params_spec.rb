# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SanitizedParams, type: :actor do
  describe '.call' do
    subject { described_class.call(permited_params:) }
    let(:permited_params) do
      params.permit(:kind, zipcodes: [])
    end

    let(:params) do
      ActionController::Parameters.new(
        {
          zipcodes: [''],
          kind: ''
        }
      )
    end

    it 'it removes the empty strings' do
      expect(subject.sanitized_params[:zipcodes]).to eq([])
      expect(subject.sanitized_params[:kind]).to eq(nil)
    end
  end
end
