require "rails_helper"

describe Api::V1::ProfilesController do
  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get :index
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      get :show, id: '12345'
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      post :create
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      put :update, id: '12345'
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      patch :update, id: '12345'
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      delete :destroy, id: '12345'
      expect(response.code).to eq "401"
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all of user's profiles" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @user = FactoryGirl.build(:user)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => @user.id)

        get 'index', :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'GET #show' do
      it "should show the profile" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @user = FactoryGirl.build(:user)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => @user.id)

        @profile = FactoryGirl.create(:profile)

        if @profile.user_id == @current_user
          get 'show', id: @profile, profile: FactoryGirl.attributes_for(:profile), :format => :json, :access_token => @token.token

          response.content_type.should eq(:json)
          response.status.should eq(200)
          assigns(:profile).should eq(@profile)
        else
          get 'show', id: FactoryGirl.create(:profile, user_id: nil)
          response.status.should eq(401)
        end
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @user = FactoryGirl.build(:user)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => @user.id)
      end

      context "with valid attributes" do
        it "creates a new profile" do
          expect{
            post :create, profile: FactoryGirl.attributes_for(:profile, :user_id => @user.id), :format => :json, :access_token => @token.token
          } .to change(Profile, :count).by(1)
        end

        it "creates a new application, making sure response is #201" do
          post :create, profile: FactoryGirl.attributes_for(:profile, :user_id => @user.id), :format => :json, :access_token => @token.token
          response.status.should eq(201)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @user = FactoryGirl.build(:user)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => @user.id)

        @profile = FactoryGirl.create(:profile, :user_id => @user.id)
      end

      context "valid attributes" do
        it "located the requested @profile" do
          put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile), :format => :json, :access_token => @token.token
          assigns(:profile).should eq(@profile)
        end

        it "changes @profile's attributes" do
          put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: "Default"), :format => :json, :access_token => @token.token
          @profile.reload
          @profile.name.should eq("Default")
        end

        it "sends a 200 if updated profile" do
          put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile), :format => :json, :access_token => @token.token
          response.status.should eq(200)
        end
      end

      context "invalid attributes" do
        it "located the requested @profile" do
          put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile), :format => :json, :access_token => @token.token
          assigns(:profile).should eq(@profile)
        end

        it "does not change @profile's attributes" do
          put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil), :format => :json, :access_token => @token.token
          @profile.reload
          @profile.name.should_not eq(nil)
        end

        it "makes sure only correct user can update" do
          put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, user_id: "2"), :format => :json, :access_token => @token.token
          @profile.reload
          @profile.name.should_not eq(nil)
        end
      end
    end

    describe "DELETE #destroy" do

      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @user = FactoryGirl.build(:user)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => @user.id)

        @profile = FactoryGirl.create(:profile, :user_id => @user.id)
      end

      it "deletes the profile" do
        expect{
          delete :destroy, id: @profile, :format => :json, :access_token => @token.token
        }.to change(Profile,:count).by(-1)
      end

      it "should have no_content" do
        delete :destroy, id: @profile, :format => :json, :access_token => @token.token
        response.status.should eq(204)
      end
    end
  end
end
