require "rails_helper"

RSpec.describe "Alpha::Applications", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      post "https://api.vcap.me:3000/v1/hackathons"
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

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
      end

      context "with valid attributes" do
        it "creates a new hackathon" do
          expect{
            post "http://api.vcap.me:3000/v1/hackathons?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          } .to change(Hackathon, :count).by(1)
        end

        it "creates a new hackathon, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/hackathons?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          response.status.should eq(201)
        end
      end
    end
  end
end