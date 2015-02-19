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
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET applications#index (accepted=nil)' do
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

    describe 'GET applications#index (accepted=true)' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      it "should show all applications to hackathon" do
        get "https://api.vcap.me:3000/v1/hackathons/1/applications?accepted=true", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end

      it "if user_id ==?" do
        if @hackathon.user_id == user.id
          get "https://api.vcap.me:3000/v1/hackathons/1/applications?accepted=true", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end

      it "if organizer?" do
        if user.organizers.where(hackathon_id: @hackathon)
          get "https://api.vcap.me:3000/v1/hackathons/1/applications?accepted=true", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end
    end

    describe 'GET applications#index (accepted=false)' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      it "should show all applications to hackathon" do
        get "https://api.vcap.me:3000/v1/hackathons/1/applications?accepted=false", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end

      it "if user_id ==?" do
        if @hackathon.user_id == user.id
          get "https://api.vcap.me:3000/v1/hackathons/1/applications?accepted=false", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end

      it "if organizer?" do
        if user.organizers.where(hackathon_id: @hackathon)
          get "https://api.vcap.me:3000/v1/hackathons/1/applications?accepted=false", :format => :json, :access_token => @token.token
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

    describe 'PUT #update --> ACCEPT' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
        @application = FactoryGirl.create(:application, hackathon_id: '1')
      end

      context "valid attributes && user_id ==?" do
        it "sanction the @application" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "changes @application's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept?access_token=#{@token.token}", :format => :json
          @application.reload
          @application.accepted.should eq(true)
        end
      end

      context "valid attributes && user_id !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept?access_token=#{@token.token}", :format => :json
          if @hackathon.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end

      context "valid attributes && organizer?" do
        it "sanction the @application" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "changes @application's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept?access_token=#{@token.token}", :format => :json
          @application.reload
          @application.accepted.should eq(true)
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/accept?access_token=#{@token.token}", :format => :json
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'PUT #update --> UNACCEPT' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
        @application = FactoryGirl.create(:application, hackathon_id: '1')
      end

      context "valid attributes && user_id ==?" do
        it "sanction the @application" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "changes @application's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept?access_token=#{@token.token}", :format => :json
          @application.reload
          @application.accepted.should eq(false)
        end
      end

      context "valid attributes && user_id !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept?access_token=#{@token.token}", :format => :json
          if @hackathon.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end

      context "valid attributes && organizer?" do
        it "sanction the @application" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "changes @application's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept?access_token=#{@token.token}", :format => :json
          @application.reload
          @application.accepted.should eq(false)
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1/applications/1/unaccept?access_token=#{@token.token}", :format => :json
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end
  end
end
