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
end
