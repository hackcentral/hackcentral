require "rails_helper"

RSpec.describe "Alpha::Hackathons", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      post "https://api.vcap.me:3000/v1/hackathons"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/hackathons/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all hackathons" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        get "https://api.vcap.me:3000/v1/hackathons", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
      end

      context "with valid attributes" do
        it "creates a new hackathon" do
          expect{
            post "http://api.vcap.me:3000/v1/hackathons?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          } .to change(Hackathon, :count).by(1)
        end

        it "creates a new hackathon, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/hackathons?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          response.status.should eq(201)
        end
      end
    end

    describe 'GET #show' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon)
      end

      it "should show the hackathon" do
        get "https://api.vcap.me:3000/v1/hackathons/#{@hackathon.id}", hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token

        @expected = {
          :id => @hackathon.id,
          :name => @hackathon.name,
          :about => @hackathon.about,
          :tagline => @hackathon.tagline,
          :location => @hackathon.location,
          :created_at => @hackathon.created_at,
          :updated_at => @hackathon.updated_at,
          :start => @hackathon.start,
          :end => @hackathon.end,
          :logo_url => @hackathon.logo_url,
          :header_url => @hackathon.header_url,
          :hs_hackers_allowed => @hackathon.hs_hackers_allowed,
          :mlh_sanctioned => @hackathon.mlh_sanctioned,
          :subdomain => @hackathon.subdomain,
          :user_id => @hackathon.user_id
        }.to_json

        response.body.should == @expected
      end

      it "status = 200" do
        get "https://api.vcap.me:3000/v1/hackathons/#{@hackathon.id}", hackathon: FactoryGirl.attributes_for(:hackathon), :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end
  end
end