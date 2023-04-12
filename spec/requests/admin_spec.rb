# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  let!(:user) { FactoryBot.create(:user, roles:) }
  let(:roles) { ['customer'] }

  describe '/admin/dashboard' do
    describe 'GET' do
      describe '302' do
        context 'when the user is not signed in' do
          it 'returns a 302 reidrects to sign_in' do
            get '/admin/dashboard'
            expect(response).to redirect_to('/users/sign_in')
          end
        end
        context 'when the user is not operationnal' do
          before do
            sign_in user
          end

          context 'When the user does not have the admin role' do
            it 'returns a 403 forbiden' do
              get '/admin/dashboard'
              expect(response).to redirect_to('/onboarding')
            end
          end
        end
      end
      describe '403' do
        before do
          sign_in user
        end
        let!(:automated_ticket) do
          FactoryBot.create(:automated_ticket, :set_up, service:, user:)
        end
        let(:service) do
          service = FactoryBot.build(:service, user_id: user.id)
          service.save(validate: false)
          service
        end

        context 'When the user does not have the admin role' do
          it 'returns a 403 forbiden' do
            get '/admin/dashboard'
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
      describe '200' do
        before do
          sign_in user
          user.add_role('admin')
        end
        let!(:automated_ticket) do
          FactoryBot.create(:automated_ticket, :set_up, service:, user:)
        end
        let(:service) do
          service = FactoryBot.build(:service, user_id: user.id)
          service.save(validate: false)
          service
        end
        context 'When the user have the admin role' do
          it 'is succesfull' do
            get '/admin/dashboard'
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end
end
