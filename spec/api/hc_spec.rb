require "rails_helper"

RSpec.describe "hc api", :type => :request do

  describe 'This method uses Doorkeepers default scopes.' do
    it "renders 401" do
      get 'https://api.vcap.me:3000/protected_with_default_scope'
      response.status.should eq(401)
      #expect(JSON.parse(response.body)).to eq [{ hello: 'protected unscoped world' }]
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