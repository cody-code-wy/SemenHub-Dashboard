require 'rails_helper'

RSpec.describe "Errors", type: :request do
  describe "GET /401" do
    it "Should return http sattus 401:unauthorised" do
      get "/401" #No helper for this
      expect(response).to have_http_status(401)
    end
  end
end
