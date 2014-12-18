require "rails_helper"

describe Api::V1::ApplicationsController do
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
    it 'GET #index' do
      @oauth_application = FactoryGirl.build(:oauth_application)
      @user = FactoryGirl.build(:user)
      @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => @user.id)
      
      get 'index', :format => :json, :access_token => @token.token
      response.status.should eq(200)
    end
  end
end


#expect(response.body).to eq({ errors: errors }.to_json)
