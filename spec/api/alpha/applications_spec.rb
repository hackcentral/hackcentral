require "rails_helper"

RSpec.describe "Alpha::Applications", :type => :request do

  let!(:user) { create(:user) }
  before { controller.stub(:current_user).and_return user }

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
      it "should show the application" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        application = FactoryGirl.create(:application)

        if application.user_id == user.id
          get "https://api.vcap.me:3000/v1/applications/#{application.id}", application: FactoryGirl.attributes_for(:application), :format => :json, :access_token => @token.token

          #assigns(:application).should eq application
          #expect(response.body).to eq application.to_json
          response.status.should eq(200)
        else
          response.status.should eq(401)
        end
      end
    end
  end
  describe "GET /applications" do
    it "returns 401" do
      get "https://api.vcap.me:3000/v1/applications"
      response.status.should eq(401)
      #expect(JSON.parse(response.body)).to eq []
    end
  end

  #describe "GET /api/statuses/:id" do
    it "returns a status by id" do
      #status = Status.create!
      #get "/api/statuses/#{status.id}"
      #expect(response.body).to eq status.to_json
    end
  #end
end