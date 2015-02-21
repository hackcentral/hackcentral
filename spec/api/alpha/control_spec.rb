require "rails_helper"

RSpec.describe "Alpha::Control", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/hackathons/1"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      delete "https://api.vcap.me:3000/v1/hackathons/1"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons/1/organizers"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      post "https://api.vcap.me:3000/v1/hackathons/1/organizers"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      delete "https://api.vcap.me:3000/v1/hackathons/1/organizers/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'PUT #update --> HACKATHON' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      context "valid attributes && user_id ==?" do
        it "locate @hackathon" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          response.status.should eq(200)
        end

        it "changes @hackathon's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          @hackathon.reload
          @hackathon.name.should eq("test")
        end
      end

      context "valid attributes && user_id !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          if @hackathon.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end

      context "valid attributes && organizer?" do
        it "sanction the @hackathon" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          response.status.should eq(200)
        end

        it "changes @hackathon's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          @hackathon.reload
          @hackathon.name.should eq("test")
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'DELETE #destroy --> HACKATHON' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => '1')
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      context "valid attributes && user_id ==?" do
        it "located the requested @hackathon" do
          get "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "deletes @hackathon" do
          delete "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
        end

        it "sends a 204" do
          delete "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          response.status.should eq(204)
        end
      end

      context "valid attributes user !=" do
        it "returns 401" do
          delete "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          if @hackathon.user_id == user.id
            response.status.should eq(204)
          else
            response.status.should eq(401)
          end
        end
      end

      context "valid attributes && organizer?" do
        it "located the requested @hackathon" do
          get "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "deletes @hackathon" do
          delete "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
        end

        it "sends a 204" do
          delete "http://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          response.status.should eq(204)
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          delete "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(204)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'GET #index --> ORGANIZERS' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => '1')
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      context "user_id ==?" do
        it "view @hackathon organizers" do
          get "https://api.vcap.me:3000/v1/hackathons/1/organizers", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        end
      end

      context "user_id !=" do
        it "returns 401" do
          get "https://api.vcap.me:3000/v1/hackathons/1/organizers", :format => :json, :access_token => @token.token
          if @hackathon.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end

      context "organizer?" do
        it "view @hackathon organizers" do
          get "https://api.vcap.me:3000/v1/hackathons/1/organizers", :format => :json, :access_token => @token.token
          response.status.should eq(200)
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          get "https://api.vcap.me:3000/v1/hackathons/1/organizers", :format => :json, :access_token => @token.token
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'POST #create --> ORGANIZER' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      context "valid attributes && user_id ==" do
        it "creates a new organizer" do
          expect{
            post "http://api.vcap.me:3000/v1/hackathons/1/organizers/?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
          } .to change(Organizer, :count).by(1)
        end

        it "creates a new application, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/hackathons/1/organizers?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
          response.status.should eq(201)
        end
      end
    end

    describe 'DELETE #destroy --> ORGANIZER' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => '1')
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
        @organizer = FactoryGirl.create(:organizer)
      end

      context "valid attributes && user_id ==?" do
        it "deletes @organizer" do
          delete "http://api.vcap.me:3000/v1/hackathons/1/organizers/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
        end

        it "sends a 204" do
          delete "http://api.vcap.me:3000/v1/hackathons/1/organizers/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
          response.status.should eq(204)
        end
      end

      context "valid attributes user !=" do
        it "returns 401" do
          delete "http://api.vcap.me:3000/v1/hackathons/1/organizers/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
          if @hackathon.user_id == user.id
            response.status.should eq(204)
          else
            response.status.should eq(401)
          end
        end
      end

      context "valid attributes && organizer?" do
        it "deletes @organizer" do
          delete "http://api.vcap.me:3000/v1/hackathons/1/organizers/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
        end

        it "sends a 204" do
          delete "http://api.vcap.me:3000/v1/hackathons/1/organizers/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
          response.status.should eq(204)
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          delete "https://api.vcap.me:3000/v1/hackathons/1/organizers/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:organizer), :format => :json
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(204)
          else
            response.status.should eq(401)
          end
        end
      end
    end
  end
end
