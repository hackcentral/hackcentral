require "rails_helper"

describe Api::V1::HackathonsController do
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
      it "should show all hackathons" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id)

        get 'index', :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'GET #show' do
      it "should show the hackathon" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id)

        @hackathon = FactoryGirl.create(:hackathon)

        get 'show', id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
        response.status.should eq(200)
        assigns(:hackathon).should eq(@hackathon)
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id)
      end

      context "with valid attributes" do
        it "creates a new hackathon" do
          expect{
            post :create, hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
          } .to change(Hackathon, :count).by(1)
        end

        it "creates a new hackathon, making sure response is #201" do
          post :create, hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
          response.status.should eq(201)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id)

        @hackathon = FactoryGirl.create(:hackathon)
      end

      context "valid attributes" do
        it "located the requested @hackathon" do
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
          assigns(:hackathon).should eq(@hackathon)
        end

        it "changes @hackathon's attributes" do
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, subdomain: "TestApps"), :format => :json, :access_token => @token.token
          @hackathon.reload
          @hackathon.subdomain.should eq("TestApps")
        end

        it "sends a 200 if updated hackathon" do
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
          response.status.should eq(200)
        end
      end

      context "invalid attributes" do
        it "located the requested @hackathon" do
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
          assigns(:hackathon).should eq(@hackathon)
        end

        it "does not change @hackathon's attributes" do
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, subdomain: nil), :format => :json, :access_token => @token.token
          @hackathon.reload
          @hackathon.subdomain.should_not eq(nil)
        end
      end
    end

    describe "DELETE #destroy" do

      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id)

        @hackathon = FactoryGirl.create(:hackathon)
      end

      it "deletes the hackathon" do
        expect{
          delete :destroy, id: @hackathon, :format => :json, :access_token => @token.token
        }.to change(Hackathon,:count).by(-1)
      end

      it "redirects to hackathon" do
        delete :destroy, id: @hackathon, :format => :json, :access_token => @token.token
        response.status.should eq(204)
      end
    end
  end
end
