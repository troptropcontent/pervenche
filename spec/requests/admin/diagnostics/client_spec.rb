require 'rails_helper'

RSpec.describe 'Admin::Diagnostics::ClientController', type: :request do
  let!(:user) { FactoryBot.create(:user, roles:) }
  let!(:automated_ticket) do
    FactoryBot.create(:automated_ticket, :set_up, user:, service:, zipcodes:, weekdays:, free:, accepted_time_units:)
  end
  let(:free) { false }
  let(:accepted_time_units) { ['days'] }
  let(:weekdays) { [Date.today.wday] }
  let(:zipcodes) { %w[75018] }
  let(:user) { FactoryBot.create(:user) }
  let(:service) do
    service = FactoryBot.build(:service, user_id: user.id, username: 'a_fake_username', password: 'a_fake_password')
    service.save(validate: false)
    service
  end
  let(:roles) { ['customer'] }

  describe 'admin/diagnostics/client/:client_kind' do
    context 'GET' do
      describe '404' do
        context 'when the :client_kind does not match the contraints' do
          it 'returns a routing error' do
            expect { get '/admin/diagnostics/client/show' }.to raise_error(ActionController::RoutingError)
          end
        end
      end
      describe '302' do
        context 'when the user is not signed in' do
          it 'returns a 302 reidrects to sign_in' do
            get '/admin/diagnostics/client/pay_by_phone'
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
            get '/admin/diagnostics/client/pay_by_phone'
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
          VCR.use_cassette('pay_by_phone_client_check') do
            get '/admin/diagnostics/client/pay_by_phone'
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end
end
