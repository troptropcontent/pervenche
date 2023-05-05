require 'rails_helper'

RSpec.describe 'Admin::Diagnostics::TicketsToRenewController', type: :request do
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes:)
  end
  let(:zipcodes) { %w[75018 75017 75016] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id)
    service.save(validate: false)
    service
  end
  let(:roles) { ['customer'] }

  describe 'admin/diagnostics/tickets_to_renew' do
    context 'GET' do
      describe '302' do
        context 'when the user is not signed in' do
          it 'returns a 302 reidrects to sign_in' do
            get '/admin/diagnostics/tickets_to_renew'
            expect(response).to redirect_to('/users/sign_in')
          end
        end
      end
      describe '403' do
        context 'when the user does not have the admin role' do
          before do
            sign_in user
          end
          it 'returns a 403 forbidden' do
            get '/admin/diagnostics/tickets_to_renew'
            expect(response).to have_http_status(:forbidden)
          end
        end
      end
      describe '200' do
        before do
          user.add_role('admin')
          sign_in user
        end
        it 'returns a 200 success' do
          get '/admin/diagnostics/tickets_to_renew'
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
