require "rails_helper"

RSpec.describe "Alpha::MLH", :type => :request do

  let!(:user) { create(:user, mlh: true) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/mlh/sanction/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do

    describe 'PUT #update --> SANCTION' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon)
      end

      context "valid attributes && user == mlh" do
        it "sanction the @hackathon" do
          put "http://api.vcap.me:3000/v1/mlh/sanction/1?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "changes @hackathon's attributes" do
          put "http://api.vcap.me:3000/v1/mlh/sanction/1?access_token=#{@token.token}", :format => :json
          @hackathon.reload
          @hackathon.mlh_sanctioned.should eq(true)
        end

        it "sends a 200 if updated hackathon if user == mlh" do
          put "http://api.vcap.me:3000/v1/mlh/sanction/1?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end
      end

      context "valid attributes && user != mlh" do
        it "returns 401" do
          put "http://api.vcap.me:3000/v1/mlh/sanction/1?access_token=#{@token.token}", :format => :json
          if user.mlh == true
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe 'PUT #update --> UNSANCTION' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon)
      end

      context "valid attributes && user == mlh" do
        it "sanction the @hackathon" do
          put "http://api.vcap.me:3000/v1/mlh/unsanction/1?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end

        it "changes @hackathon's attributes" do
          put "http://api.vcap.me:3000/v1/mlh/unsanction/1?access_token=#{@token.token}", :format => :json
          @hackathon.reload
          @hackathon.mlh_sanctioned.should eq(false)
        end

        it "sends a 200 if updated hackathon if user == mlh" do
          put "http://api.vcap.me:3000/v1/mlh/unsanction/1?access_token=#{@token.token}", :format => :json
          response.status.should eq(200)
        end
      end

      context "valid attributes && user != mlh" do
        it "returns 401" do
          put "http://api.vcap.me:3000/v1/mlh/unsanction/1?access_token=#{@token.token}", :format => :json
          if user.mlh == true
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end

  end
end
