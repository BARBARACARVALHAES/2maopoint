require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    login_as(user)
  end

  describe "GET /profiles" do
    it "can access my profile" do
      get(profile_path(user))
      expect(response).to have_http_status(200)
    end

    it "can't access profile of another user" do
      get(profile_path(other_user))
      expect(response).to have_http_status(200)
    end
  end
end
