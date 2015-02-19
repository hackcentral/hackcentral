require "rails_helper"

RSpec.describe "Alpha::Control", :type => :request do

  let!(:user) { create(:user, mlh: true) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons/1/applications"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons/1/applications/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET applications#index' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      it "should show all applications to hackathon" do
        get "https://api.vcap.me:3000/v1/hackathons/1/applications", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end

      it "if user_id ==?" do
        if @hackathon.user_id == user.id
          get "https://api.vcap.me:3000/v1/hackathons/1/applications", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end

      it "if organizer?" do
        if user.organizers.where(hackathon_id: @hackathon)
          get "https://api.vcap.me:3000/v1/hackathons/1/applications", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end
    end

    describe 'GET applications#show' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
        @application = FactoryGirl.create(:application, hackathon_id: '1')
      end

      it "should show application to hackathon" do
        get "https://api.vcap.me:3000/v1/hackathons/1/applications/1", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end

      it "if user_id ==?" do
        if @hackathon.user_id == user.id
          get "https://api.vcap.me:3000/v1/hackathons/1/applications/1", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end

      it "if organizer?" do
        if user.organizers.where(hackathon_id: @hackathon)
          get "https://api.vcap.me:3000/v1/hackathons/1/applications/1", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end
    end
  end
end
