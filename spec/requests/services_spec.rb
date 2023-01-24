require 'rails_helper'

RSpec.describe "Services", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/services/new"
      expect(response).to have_http_status(:success)
    end
  end

end
