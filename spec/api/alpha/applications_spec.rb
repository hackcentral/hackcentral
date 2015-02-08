require "rails_helper"

RSpec.describe "Alpha::Applications", :type => :request do

  # Make sure everything returns 401
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