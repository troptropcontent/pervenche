require 'rails_helper'

RSpec.describe "AutomatedTickets::Setups", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/automated_tickets/setup/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/automated_tickets/setup/update"
      expect(response).to have_http_status(:success)
    end
  end

end
