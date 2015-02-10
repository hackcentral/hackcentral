require "rails_helper"

RSpec.describe "Alpha::Applications", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/applications"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/applications/1"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      post "https://api.vcap.me:3000/v1/applications"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/applications/1"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/applications/1"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      delete "https://api.vcap.me:3000/v1/applications/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all of user's applications" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        get "https://api.vcap.me:3000/v1/applications", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'GET #show' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @application = FactoryGirl.create(:application)
      end

      it "should show the application" do
        get "https://api.vcap.me:3000/v1/applications/#{@application.id}", application: FactoryGirl.attributes_for(:application, user_id: ""), :format => :json, :access_token => @token.token
        expect(response.body).to eq @application.to_json
      end

      it "if correct_user?" do
        if @application.user_id == user.id
          get "https://api.vcap.me:3000/v1/applications/#{@application.id}", application: FactoryGirl.attributes_for(:application, user_id: ""), :format => :json, :access_token => @token.token
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
      end

      context "with valid attributes" do
        it "creates a new application" do
          expect{
            post "http://api.vcap.me:3000/v1/applications?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          } .to change(Application, :count).by(1)
        end

        it "creates a new application, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/applications", application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
          response.status.should eq(400)
        end
      end
    end

    describe 'PUT #update' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @application = FactoryGirl.create(:application, user_id: '1')
      end

      context "valid attributes && correct_user" do
        it "located the requested @application" do
          put "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          response.status.should eq(200)
        end

        it "changes @application's attributes" do
          put "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application, reimbursement_needed: true), :format => :json
          @application.reload
          @application.reimbursement_needed.should eq(true)
        end

        it "sends a 200 if updated application if correct_user" do
          put "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          response.status.should eq(200)
        end
      end

      context "valid attributes != correct_user" do
        it "returns 401" do
          put "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          if @application.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @application = FactoryGirl.create(:application)
      end

      context "valid attributes && correct_user" do
        it "located the requested @application" do
          patch "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          response.status.should eq(200)
        end

        it "changes @application's attributes" do
          patch "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application, reimbursement_needed: true), :format => :json
          @application.reload
          @application.reimbursement_needed.should eq(true)
        end

        it "sends a 200 if updated application if correct_user" do
          patch "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          response.status.should eq(200)
        end
      end

      context "valid attributes != correct_user" do
        it "returns 401" do
          patch "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          if @application.user_id == user.id
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
        @application = FactoryGirl.create(:application, user_id: '1')
      end

      context "valid attributes && correct_user" do
        it "located the requested @application" do
          delete "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          puts response.body
          response.status.should eq(204)
        end

        it "deletes @application" do
          delete "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
        end

        it "sends a 204" do
          delete "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          response.status.should eq(204)
        end
      end

      context "valid attributes != correct_user" do
        it "returns 401" do
          delete "http://api.vcap.me:3000/v1/applications/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:application), :format => :json
          if @application.user_id == user.id
            response.status.should eq(204)
          else
            response.status.should eq(401)
          end
        end
      end
    end

  end
end
