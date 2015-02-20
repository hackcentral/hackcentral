require "rails_helper"

RSpec.describe "Alpha::Control", :type => :request do

  let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      put "https://api.vcap.me:3000/v1/hackathons/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'PUT #update' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon, user_id: '1')
      end

      context "valid attributes && user_id ==?" do
        it "locate @hackathon" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          response.status.should eq(200)
        end

        it "changes @hackathon's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          @hackathon.reload
          @hackathon.name.should eq("test")
        end
      end

      context "valid attributes && user_id !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          if @hackathon.user_id == user.id
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end

      context "valid attributes && organizer?" do
        it "sanction the @hackathon" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon), :format => :json
          response.status.should eq(200)
        end

        it "changes @hackathon's attributes" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          @hackathon.reload
          @hackathon.name.should eq("test")
        end
      end

      context "valid attributes && organizer !=" do
        it "returns 401" do
          put "https://api.vcap.me:3000/v1/hackathons/1?access_token=#{@token.token}", FactoryGirl.attributes_for(:hackathon, name: "test"), :format => :json
          if user.organizers.where(hackathon_id: @hackathon)
            response.status.should eq(200)
          else
            response.status.should eq(401)
          end
        end
      end
    end
  end
end
