require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  path '/notifications/:type' do
    let(:type) { 'VehicleAtRiskNotification' }
    post 'create' do
      it_behaves_like 'An authenticated endpoint'
      context 'when the user is not admin' do
        let(:user) { FactoryBot.create(:user, roles: ['customer']) }
        let(:user_roles) { ['customer'] }
        before { sign_in user }
        it 'raises an error' do |example|
          expect { run example }.to raise_error(ActionController::RoutingError)
        end
      end
      response '204', 'No Content' do
        let(:user) { FactoryBot.create(:user, roles: ['admin']) }
        let(:service) { FactoryBot.create(:service, :without_validations, username: '+33678901234', password: 'password') }
        let(:automated_ticket) { FactoryBot.create(:automated_ticket, :set_up, service:) }
        before { sign_in user }
        request_body do
          {
            notification: {
              recipient_id: user.id,
              user_email: user.email,
              license_plate: automated_ticket.license_plate,
              zipcode: automated_ticket.zipcodes.first,
              uncovered_since: 1.day.ago,
              automated_ticket_id: automated_ticket.id
            }
          }
        end
        it 'raises an error' do |example|
          run example
        end
      end
    end
  end
end
