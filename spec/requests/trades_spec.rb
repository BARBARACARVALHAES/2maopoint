require 'rails_helper'

RSpec.describe "Trades", type: :request do
  describe "GET /trades" do
    it "Redirected when access new" do
      get new_trade_path
      expect(response).to have_http_status(302)
    end
  end
end
