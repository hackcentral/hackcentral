require "rails_helper"

RSpec.describe "Alpha::Applications", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all hackathons" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        get "https://api.vcap.me:3000/v1/hackathons", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end
  end
end