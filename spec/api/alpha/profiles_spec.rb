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

    describe 'GET #show' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @profile = FactoryGirl.create(:profile)
      end

      it "should show the profile" do
        get "https://api.vcap.me:3000/v1/profiles/#{@profile.id}", profile: FactoryGirl.attributes_for(:profile, user_id: ""), :format => :json, :access_token => @token.token

        @expected = {
          :id => @profile.id,
          :name => @profile.name,
          :school_grad => @profile.school_grad,
          :website => @profile.website,
          :github => @profile.github,
          :created_at => @profile.created_at,
          :updated_at => @profile.updated_at,
          :resume => @profile.resume,
          :dietary_needs => @profile.dietary_needs,
          :user_id => @profile.user_id
        }.to_json

        response.body.should == @expected
        response.status.should eq(200)
      end

      it "if correct_user?" do
        if @profile.user_id == user.id
          get "https://api.vcap.me:3000/v1/profiles/#{@profile.id}", profile: FactoryGirl.attributes_for(:profile, user_id: ""), :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @profile = FactoryGirl.create(:profile, user_id: '1')
      end

      context "valid attributes && correct_user" do
        it "located the requested @profile" do
          put "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          response.status.should eq(200)
        end

        it "changes @profile's attributes" do
          put "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile, dietary_needs: "default"), :format => :json
          @profile.reload
          @profile.dietary_needs.should eq("default")
        end

        it "sends a 200 if updated profile if correct_user" do
          put "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          response.status.should eq(200)
        end
      end

      context "valid attributes != correct_user" do
        it "returns 401" do
          put "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          if @profile.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => '1')#user.id)
        @profile = FactoryGirl.create(:profile, user_id: '1')
      end

      context "valid attributes && correct_user" do
        it "located the requested @profile" do
          delete "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          puts response.body
          response.status.should eq(204)
        end

        it "deletes @profile" do
          delete "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
        end

        it "sends a 204" do
          delete "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          response.status.should eq(204)
        end
      end

      context "valid attributes != correct_user" do
        it "returns 401" do
          delete "http://api.vcap.me:3000/v1/profiles/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:profile), :format => :json
          if @profile.user_id == user.id
            response.status.should eq(204)
          else
            response.status.should eq(401)
          end
        end
      end
    end

  end
end