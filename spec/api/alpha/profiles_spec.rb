require "rails_helper"

RSpec.describe "Alpha::Profiles", :type => :request do
  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/profiles"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all of user's applications" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        get "https://api.vcap.me:3000/v1/profiles", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
      end

      context "with valid attributes" do
        it "creates a new profile" do
          expect{
            post "http://api.vcap.me:3000/v1/profiles?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          } .to change(Profile, :count).by(1)
        end

        it "creates a new profile, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/profiles?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          response.status.should eq(201)
        end
      end
    end
  end
end