require 'rails_helper'

RSpec.describe "Setups", type: :request do
  describe "GET /service" do
    it "returns http success" do
      get "/setup/service"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /localisation" do
    it "returns http success" do
      get "/setup/localisation"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /vehicle" do
    it "returns http success" do
      get "/setup/vehicle"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /zipcode" do
    it "returns http success" do
      get "/setup/zipcode"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /rate_options" do
    it "returns http success" do
      get "/setup/rate_options"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /weekdays" do
    it "returns http success" do
      get "/setup/weekdays"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /payment_methods" do
    it "returns http success" do
      get "/setup/payment_methods"
      expect(response).to have_http_status(:success)
    end
  end

end
