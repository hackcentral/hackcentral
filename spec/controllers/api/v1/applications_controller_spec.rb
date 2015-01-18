require "rails_helper"

describe Api::V1::ApplicationsController do

  let!(:user) { create(:user) }
  before { controller.stub(:current_user).and_return user }

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
      it "should show all of user's applications" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        get 'index', :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'GET #show' do
      it "should show the application" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        @application = FactoryGirl.create(:application)

        if @application.user_id == user.id
          get 'show', id: @application, application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
          response.status.should eq(200)
          assigns(:application).should eq(@application)
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
            post :create, application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
          } .to change(Application, :count).by(1)
        end

        it "creates a new application, making sure response is #201" do
          post :create, application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
          response.status.should eq(201)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @application = FactoryGirl.create(:application)
      end

      context "valid attributes" do
        it "located the requested @application" do
          put :update, id: @application, application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
          assigns(:application).should eq(@application)
        end

        it "changes @application's attributes" do
          put :update, id: @application, application: FactoryGirl.attributes_for(:application, reimbursement_needed: true), :format => :json, :access_token => @token.token
          @application.reload
          @application.reimbursement_needed.should eq(true)
        end

        it "sends a 200 if updated application if correct_user" do
          if @application.user_id == user.id
            put :update, id: @application, application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end

      context "invalid attributes" do
        it "located the requested @application" do
          put :update, id: @application, application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token
          assigns(:application).should eq(@application)
        end

        it "does not change @application's attributes" do
          put :update, id: @application, application: FactoryGirl.attributes_for(:application, reimbursement_needed: "a"), :format => :json, :access_token => @token.token
          @application.reload
          @application.reimbursement_needed.should_not eq("a")
        end

        it "makes sure only correct user can update" do
          put :update, id: @application, application: FactoryGirl.attributes_for(:application, user_id: "2", reimbursement_needed: "true"), :format => :json, :access_token => @token.token
          @application.reload
          @application.reimbursement_needed.should_not eq("true")
        end
      end
    end

    describe "DELETE #destroy" do

      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @application = FactoryGirl.create(:application)
      end

      it "deletes the application" do
        if @application.user_id == user.id
          expect{
            delete :destroy, id: @application, :format => :json, :access_token => @token.token
          }.to change(Application,:count).by(-1)
        else
          response.status.should eq(401)
        end
      end

      it "redirects to applications#index" do
        if @application.user_id == user.id
          delete :destroy, id: @application, :format => :json, :access_token => @token.token
          response.status.should eq(204)
        else
          response.status.should eq(401)
        end
      end
    end
  end
end
