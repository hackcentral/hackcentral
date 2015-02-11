require "rails_helper"

RSpec.describe "Alpha::Users", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/user"
      response.status.should eq(401)
    end
  end

  context "with access token" do

    describe 'GET #show' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
      end

      it "should show the current_user's profile" do
        get "https://api.vcap.me:3000/v1/user", :format => :json, :access_token => @token.token

        @expected = {
          :id => user.id,
          :created_at => user.created_at,
          :updated_at => user.updated_at,
          :name => user.name,
          :bio => user.bio,
          :username => user.username
        }.to_json

        response.body.should == @expected
      end
    end

  end
end
