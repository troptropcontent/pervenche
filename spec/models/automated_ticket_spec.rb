require 'rails_helper'

RSpec.describe AutomatedTicket, type: :model do
  subject { 
    FactoryBot.create(:automated_ticket, user:, service:) 
  }
  let(:service) do
    service = FactoryBot.build(:service, user:)
    service.save(validate: false)
    service
  end
  let(:user){FactoryBot.create(:user)}

  describe 'validations' do
    context 'uniqueness' do
      let(:user) do
        user = FactoryBot.build(:user)
        user.save(validate: false)
        user
      end
      let(:service) do
        service = FactoryBot.build(:service, user_id: user.id)
        service.save(validate: false)
        service
      end
      let!(:automated_ticket) do
        FactoryBot.build(
          :automated_ticket,
          user_id: user.id,
          service: service
        )
      end
      context 'license_plate' do
        it { should validate_uniqueness_of(:license_plate).scoped_to(%i[user_id service_id]) }
      end
    end
    context 'presence' do
      it 'We should have here all specs related to the conditionnal validation that we have on the model'
    end
  end
  describe "#instance_methods" do
    context "#find_or_create_running_ticket_if_it_exists" do
      before do
        allow(subject).to receive(:running_ticket_in_client).and_return(running_ticket_in_client)
      end
      let(:running_ticket_in_client){nil}
      context "when a running ticket exists in the database" do
        let!(:running_ticket_in_database) {FactoryBot.create(:ticket, automated_ticket: subject, ends_on: 2.minutes.from_now)}
        it "returns the running ticket" do
          expect(subject.find_or_create_running_ticket_if_it_exists).to eq(running_ticket_in_database)
        end
      end
      context "when a running ticket does not exist in the database" do
        
        context "when a ticket exist in the client" do
          let(:running_ticket_in_client){{
            starts_on: "2023-01-25 13:35:58".to_datetime.in_time_zone,
            ends_on: "2023-01-25 13:35:58".to_datetime.in_time_zone,
            license_plate: "MyLicensePlate",
            cost: 1,
            client_internal_id: "FakeClientInternalId",
            client: 'pay_by_phone',
          }}
          it "creates a new ticket in the database and returns it" do
            ticket_count = Ticket.count
            result = subject.find_or_create_running_ticket_if_it_exists
            expect(**result.attributes).to include(**running_ticket_in_client.except(:client, :cost).stringify_keys)
            expect(result.cost_cents).to eq(100)
            expect( Ticket.count).to eq(ticket_count + 1)
          end
        end
        context "when a ticket does not exist in the client" do
          it "return null" do
            expect(subject.find_or_create_running_ticket_if_it_exists).to eq(nil)
          end
        end
      end
    end
  end
  
end
