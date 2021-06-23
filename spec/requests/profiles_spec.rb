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

    it "can access his convites" do
      get(invitations_profile_path(user))
      expect(response).to have_http_status(200)
    end

    it "can't access profile of another user" do
      expect{ get(profile_path(other_user)) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
