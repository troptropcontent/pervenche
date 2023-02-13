require 'rails_helper'

RSpec.describe 'AutomatedTickets::Setups', type: :request do
  let(:user) do
    user = FactoryBot.build(:user)
    user.save(validate: false)
    user
  end

  describe '/automated_tickets/:automated_ticket_id/setups/:id' do
    let(:path) { "/automated_tickets/#{automated_ticket_id}/setups/#{id}" }
    let(:automated_ticket_id) {}
    let(:id) {}
    let!(:automated_ticket) do
      automated_ticket = FactoryBot.build(
        :automated_ticket,
        user_id: user.id,
        service: service,
        rate_option_client_internal_id: rate_option_client_internal_id,
        license_plate: license_plate,
        zipcode: zipcode,
        weekdays: weekdays,
        accepted_time_units: accepted_time_units,
        payment_method_client_internal_id: payment_method_client_internal_id,
        status: status
      )
      automated_ticket.save(validate: false)
      automated_ticket
    end
    let(:service) { nil }
    let(:rate_option_client_internal_id) { nil }
    let(:license_plate) { nil }
    let(:zipcode) { nil }
    let(:weekdays) { nil }
    let(:accepted_time_units) { nil }
    let(:payment_method_client_internal_id) { nil }
    let(:status) { 'initialized' }
    RSpec.shared_context 'service step done', shared_context: :metadata do
      let(:service) do
        service = FactoryBot.build(:service, user_id: user.id)
        service.save(validate: false)
        service
      end
    end
    RSpec.shared_context 'license_plate_and_zipcode step done', shared_context: :metadata do
      include_context 'service step done'
      let(:license_plate) { 'XXXXXXXX' }
      let(:zipcode) { '75018' }
    end
    RSpec.shared_context 'rate_option step done', shared_context: :metadata do
      include_context 'license_plate_and_zipcode step done'
      let(:rate_option_client_internal_id) { 'XXXXXXXX' }
      let(:accepted_time_units) { ['days'] }
    end
    RSpec.shared_context 'duration_and_payment_method step done', shared_context: :metadata do
      include_context 'rate_option step done'
      let(:payment_method_client_internal_id) { 'XXXXXXXX' }
      let(:weekdays) { [1, 2, 3] }
      let(:status) { 'ready' }
    end

    describe 'GET' do
      before do
        sign_in(user)
      end
      context '404' do
        context 'when the step does not exists' do
          let!(:automated_ticket) do
            automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
            automated_ticket.save(validate: false)
            automated_ticket
          end
          let(:automated_ticket_id) { automated_ticket.id }
          let(:id) { 'fake_step' }

          it 'returns a 404' do
            expect { get path }.to raise_error(ActionController::RoutingError)
          end
        end
        context 'when the automated_ticket does not exists' do
          let(:automated_ticket_id) { 'fake_id' }
          let(:id) { 'fake_step' }

          it 'returns a 404' do
            expect { get path }.to raise_error(ActionController::RoutingError)
          end
        end
      end
      context '403' do
        context 'when a user tries to access another user automated_ticket' do
          let!(:automated_ticket) do
            automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
            automated_ticket.save(validate: false)
            automated_ticket
          end
          let(:automated_ticket_id) { automated_ticket.id }
          let(:id) { 'service' }
          let(:another_user) { FactoryBot.create(:user, email: 'tom@example.com') }
          before do
            sign_in(another_user)
          end
          it 'returns a 403' do
            get path
            expect(response).to have_http_status(403)
          end
        end
        context 'when a user tries to setup an already set up automated_ticket' do
          let!(:automated_ticket) do
            automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil, status: :ready)
            automated_ticket.save(validate: false)
            automated_ticket
          end
          let(:automated_ticket_id) { automated_ticket.id }
          let(:id) { 'service' }
          it 'returns a 403' do
            get path
            expect(response).to have_http_status(403)
          end
        end
      end

      context '200' do
        let!(:automated_ticket) do
          automated_ticket = FactoryBot.build(
            :automated_ticket,
            user_id: user.id,
            service: service,
            rate_option_client_internal_id: rate_option_client_internal_id,
            license_plate: license_plate,
            zipcode: zipcode,
            weekdays: weekdays,
            accepted_time_units: accepted_time_units,
            payment_method_client_internal_id: payment_method_client_internal_id,
            status: status
          )
          automated_ticket.save(validate: false)
          automated_ticket
        end
        let(:service) { nil }
        let(:rate_option_client_internal_id) { nil }
        let(:license_plate) { nil }
        let(:zipcode) { nil }
        let(:weekdays) { nil }
        let(:accepted_time_units) { nil }
        let(:payment_method_client_internal_id) { nil }
        let(:status) { 'initialized' }
        RSpec.shared_context 'service step done', shared_context: :metadata do
          let(:service) do
            service = FactoryBot.build(:service, user_id: user.id)
            service.save(validate: false)
            service
          end
        end
        RSpec.shared_context 'license_plate_and_zipcode step done', shared_context: :metadata do
          include_context 'service step done'
          let(:license_plate) { 'XXXXXXXX' }
          let(:zipcode) { '75018' }
        end
        RSpec.shared_context 'rate_option step done', shared_context: :metadata do
          include_context 'license_plate_and_zipcode step done'
          let(:rate_option_client_internal_id) { 'XXXXXXXX' }
          let(:accepted_time_units) { ['days'] }
        end
        RSpec.shared_context 'duration_and_payment_method step done', shared_context: :metadata do
          include_context 'rate_option step done'
          let(:payment_method_client_internal_id) { 'XXXXXXXX' }
          let(:weekdays) { [1, 2, 3] }
          let(:status) { 'ready' }
        end

        let(:automated_ticket_id) { automated_ticket.id }
        let(:id) { 'service' }
        context 'service step' do
          context 'when the step is already done' do
            include_context 'service step done'
            it 'redirects to the next step' do
              get path
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/license_plate_and_zipcode")
            end
          end

          context 'when the step not done' do
            it 'renders the correct template' do
              get path
              expect(response).to have_http_status(200)
              expect(response).to render_template('automated_tickets/setups/wizard')
            end
          end
        end
        context 'license_plate_and_zipcode step' do
          let(:id) { 'license_plate_and_zipcode' }
          context 'when the step is already done' do
            include_context 'license_plate_and_zipcode step done'
            it 'redirects to the next step' do
              get path
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/rate_option")
            end
          end

          context 'when the step not done' do
            it 'renders the correct template' do
              get path
              expect(response).to have_http_status(200)
              expect(response).to render_template('automated_tickets/setups/wizard')
            end
          end
        end
        context 'rate_option step' do
          let(:id) { 'rate_option' }
          context 'when the step is already done' do
            include_context 'rate_option step done'
            it 'redirects to the next step' do
              get path
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/duration_and_payment_method")
            end
          end

          context 'when the step not done' do
            it 'renders the correct template' do
              get path
              expect(response).to have_http_status(200)
              expect(response).to render_template('automated_tickets/setups/wizard')
            end
          end
        end
        context 'duration_and_payment_method step' do
          let(:id) { 'duration_and_payment_method' }
          context 'when the step not done' do
            it 'renders the correct template' do
              get path
              expect(response).to have_http_status(200)
              expect(response).to render_template('automated_tickets/setups/wizard')
            end
          end
        end
      end
    end
    describe 'PUT' do
      before do
        sign_in(user)
      end
      describe '404' do
        context 'when the step does not exists' do
          let!(:automated_ticket) do
            automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
            automated_ticket.save(validate: false)
            automated_ticket
          end
          let(:automated_ticket_id) { automated_ticket.id }
          let(:id) { 'fake_step' }

          it 'returns a 404' do
            expect { put path }.to raise_error(ActionController::RoutingError)
          end
        end
        context 'when the automated_ticket does not exists' do
          let(:automated_ticket_id) { 'fake_id' }
          let(:id) { 'fake_step' }

          it 'returns a 404' do
            expect { put path }.to raise_error(ActionController::RoutingError)
          end
        end
      end
      describe '403' do
        context 'when a user tries to access another user automated_ticket' do
          let!(:automated_ticket) do
            automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil)
            automated_ticket.save(validate: false)
            automated_ticket
          end
          let(:automated_ticket_id) { automated_ticket.id }
          let(:id) { 'service' }
          let(:another_user) { FactoryBot.create(:user, email: 'tom@example.com') }
          before do
            sign_in(another_user)
          end
          it 'returns a 403' do
            put path
            expect(response).to have_http_status(403)
          end
        end
        context 'when a user tries to setup an already set up automated_ticket' do
          let!(:automated_ticket) do
            automated_ticket = FactoryBot.build(:automated_ticket, user_id: user.id, service: nil, status: :ready)
            automated_ticket.save(validate: false)
            automated_ticket
          end
          let(:automated_ticket_id) { automated_ticket.id }
          let(:id) { 'service' }
          it 'returns a 403' do
            put path
            expect(response).to have_http_status(403)
          end
        end
      end
      describe '422' do
        context 'service step' do
          let(:id) { 'service' }
          let(:automated_ticket_id) { automated_ticket.id }
          context 'when the updated automated_ticket is not valid' do
            let(:params) do
              {
                automated_ticket: {
                  service_id: nil
                }
              }
            end
            it 'returns the wizard in synchron mode with errors on the model' do
              put path, params: params
              expect(response).to have_http_status(422)
              expect(response).to render_template('automated_tickets/setups/wizard')
              expect(assigns(:load_content_later)).to eq false
              expect(assigns(:automated_ticket).errors.full_messages).to eq ["Service can't be blank"]
            end
          end
        end
        context 'license_plate_and_zipcode step' do
          let(:id) { 'license_plate_and_zipcode' }
          let(:automated_ticket_id) { automated_ticket.id }
          include_context 'service step done'
          let(:params) do
            {
              automated_ticket: {
                license_plate: nil,
                zipcode: nil
              }
            }
          end
          it 'returns the wizard in synchron mode with errors on the model' do
            service_double = instance_double(Service, vehicles: [])
            allow(AutomatedTicket).to receive(:find).and_return(automated_ticket)
            allow(automated_ticket).to receive(:service).and_return(service_double)

            put path, params: params
            expect(response).to have_http_status(422)
            expect(response).to render_template('automated_tickets/setups/wizard')
            expect(assigns(:load_content_later)).to eq false
            expect(assigns(:automated_ticket).errors.full_messages).to eq ["License plate can't be blank",
                                                                           "Zipcode can't be blank"]
          end
        end
        context 'rate_option step' do
          let(:id) { 'rate_option' }
          let(:automated_ticket_id) { automated_ticket.id }
          include_context 'license_plate_and_zipcode step done'
          let(:params) do
            {
              automated_ticket: {
                rate_option_client_internal_id: nil,
                accepted_time_units: nil
              }
            }
          end
          it 'returns the wizard in synchron mode with errors on the model' do
            service_double = instance_double(Service, rate_options: [])
            allow(AutomatedTicket).to receive(:find).and_return(automated_ticket)
            allow(automated_ticket).to receive(:service).and_return(service_double)

            put path, params: params
            expect(response).to have_http_status(422)
            expect(response).to render_template('automated_tickets/setups/wizard')
            expect(assigns(:load_content_later)).to eq false
            expect(assigns(:automated_ticket).errors.full_messages).to eq [
              "Rate option client internal can't be blank", "Accepted time units can't be blank"
            ]
          end
        end
        context 'duration_and_payment_method step' do
          let(:id) { 'duration_and_payment_method' }
          let(:automated_ticket_id) { automated_ticket.id }
          include_context 'rate_option step done'
          let(:params) do
            {
              automated_ticket: {
                payment_method_client_internal_id: nil,
                weekdays: nil
              }
            }
          end
          it 'returns the wizard in synchron mode with errors on the model' do
            service_double = instance_double(Service, payment_methods: [])
            allow(AutomatedTicket).to receive(:find).and_return(automated_ticket)
            allow(automated_ticket).to receive(:service).and_return(service_double)

            put path, params: params
            expect(response).to have_http_status(422)
            expect(response).to render_template('automated_tickets/setups/wizard')
            expect(assigns(:load_content_later)).to eq false
            expect(assigns(:automated_ticket).errors.full_messages).to eq [
              "Payment method client internal can't be blank", "Weekdays can't be blank"
            ]
          end
        end
      end
      context '302' do
        let(:automated_ticket_id) { automated_ticket.id }
        context 'service step' do
          context 'when the updated record is valid' do
            let(:id) { 'service' }
            let(:a_service) do
              service = FactoryBot.build(:service, user_id: user.id)
              service.save(validate: false)
              service
            end
            let(:params) do
              {
                automated_ticket: {
                  service_id: a_service.id
                }
              }
            end
            it 'updates the record and redirects to the next step' do
              put path, params: params
              expect(response).to have_http_status(302)
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/license_plate_and_zipcode")
              expect(automated_ticket.reload.service_id).to eq(a_service.id)
            end
          end
        end
        context 'license_plate_and_zipcode step' do
          let(:id) { 'license_plate_and_zipcode' }
          context 'when the updated record is valid' do
            include_context 'service step done'
            let(:params) do
              {
                automated_ticket: {
                  license_plate: 'TESTLICENCEPLATE',
                  zipcode: 'TESTZIPCODE'
                }
              }
            end
            it 'updates the record and redirects to the next step' do
              put path, params: params
              expect(response).to have_http_status(302)
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/rate_option")
              expect(automated_ticket.reload.zipcode).to eq('TESTZIPCODE')
              expect(automated_ticket.reload.license_plate).to eq('TESTLICENCEPLATE')
            end
          end
        end
        context 'rate_option step' do
          let(:id) { 'rate_option' }
          context 'when the updated record is valid' do
            include_context 'license_plate_and_zipcode step done'
            let(:params) do
              {
                automated_ticket: {
                  rate_option_client_internal_id: 'TESTLCLIENTRATEOPTIONID',
                  accepted_time_units: ['days']
                }
              }
            end
            it 'updates the record and redirects to the next step' do
              put path, params: params
              expect(response).to have_http_status(302)
              expect(response).to redirect_to("/automated_tickets/#{automated_ticket.id}/setups/duration_and_payment_method")
              expect(automated_ticket.reload.rate_option_client_internal_id).to eq('TESTLCLIENTRATEOPTIONID')
              expect(automated_ticket.reload.accepted_time_units).to eq(['days'])
            end
          end
        end
        context 'duration_and_payment_method step' do
          let(:id) { 'duration_and_payment_method' }
          context 'when the updated record is valid' do
            include_context 'rate_option step done'
            let(:params) do
              {
                automated_ticket: {
                  payment_method_client_internal_id: 'TESTCLIENTPAYMENTMETHODID',
                  weekdays: [1, 2, 3]
                }
              }
            end
            it 'updates the record and redirects to the root as it was the last step' do
              put path, params: params
              expect(response).to have_http_status(302)
              expect(response).to redirect_to(root_path)
              expect(automated_ticket.reload.payment_method_client_internal_id).to eq('TESTCLIENTPAYMENTMETHODID')
              expect(automated_ticket.reload.weekdays).to eq([1, 2, 3])
            end
          end
        end
      end
    end
  end

  describe '/automated_tickets/:automated_ticket_id/setups/:id/content' do
    let(:path) { "/automated_tickets/#{automated_ticket_id}/setups/#{id}/content" }
    let(:automated_ticket_id) {}
    let(:id) {}
  end
end
