# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Services', type: :request do
  describe '/services' do
    context 'POST' do
      describe 'services#create' do
        context 'when the username is not valid' do
          describe '302' do
            context 'when the user is not signed in' do
              it 'returns a 302 reidrects to sign_in' do
                post '/services', params: { service: { username: 'toto' } }
                expect(response).to redirect_to('/users/sign_in')
              end
            end
          end
          describe '422' do
            before do
              sign_in FactoryBot.create(:user)
            end
            context 'when the username is not valid' do
              it 'returns a 422: Unprocessable Entity' do
                allow(ParkingTicket::Base).to receive(:valid_credentials?).and_return(true)
                post '/services', params: { service: { username: 'toto', password: 'password', kind: 'pay_by_phone' } }
                expect(response).to have_http_status(:unprocessable_entity)
              end
            end
            context 'when the password is not there' do
              it 'returns a 422: Unprocessable Entity' do
                post '/services', params: { service: { username: '+33612345678', kind: 'pay_by_phone' } }
                expect(response).to have_http_status(:unprocessable_entity)
              end
            end
            context 'when the kind is not there' do
              it 'returns a 422: Unprocessable Entity' do
                post '/services', params: { service: { username: '+33612345678', password: 'password' } }
                expect(response).to have_http_status(:unprocessable_entity)
              end
            end
          end
          describe '302' do
            before do
              sign_in FactoryBot.create(:user)
            end
            context 'when the username is not valid' do
              it 'returns a 302: Redirect to the onboarding' do
                allow(ParkingTicket::Base).to receive(:valid_credentials?).and_return(true)
                expect do
                  post('/services',
                       params: { service: { username: '+33612345678', password: 'password', kind: 'pay_by_phone' } })
                end.to change(Service, :count).by(1)
                expect(response).to redirect_to('/')
              end
            end
          end
        end
      end
    end
  end

  path '/services/:id' do
    let(:user) { FactoryBot.create(:user) }
    let(:service) { FactoryBot.create(:service, :without_validations, user:) }
    let(:id) { service.id }
    put '#update' do
      it_behaves_like 'An authenticated endpoint'

      response '422', 'Unprocessable Entity' do
        before { sign_in user }
        context 'when the updated service is not valid' do
          include_context 'stubed pay_by_phone failed auth', 'toto', 'tata'
          params do
            { service: {
              username: 'toto',
              password: 'tata'
            } }
          end
          it 'returns a 422' do |example|
            run example
          end
        end
      end
      response '302', 'Found' do
        before { sign_in user }
        context 'when the updated service is valid' do
          include_context 'stubed pay_by_phone auth', '+33612345678', 'correct_password'
          params do
            { service: {
              username: '+33612345678',
              password: 'correct_password'
            } }
          end
          it 'redirect to the root' do |example|
            expect(run(example)).to redirect_to('/')
          end
        end
      end
    end
  end
  describe '/services/new' do
    context 'GET' do
      describe 'services#new' do
        it 'returns the new service page'
      end
    end
  end
end
