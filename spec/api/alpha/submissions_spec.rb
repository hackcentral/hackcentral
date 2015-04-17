require "rails_helper"

RSpec.describe "Alpha::Submissions", :type => :request do

    let!(:user) { create(:user) }

  context "no access token" do
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/submissions"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      post "https://api.vcap.me:3000/v1/hackathons/1/submissions"
      response.status.should eq(401)
    end
    it 'returns a 401 when users are not authenticated' do
      get "https://api.vcap.me:3000/v1/submissions/1"
      response.status.should eq(401)
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all of hackathon's submissions" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.build(:hackathon)
        @submission = FactoryGirl.build(:submission, hackathon_id: '1')

        get "https://api.vcap.me:3000/v1/submissions?hackathon_id=#{@hackathon.id}", :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'GET #show' do
      it "should show the submission if submitted" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon)
        @submission = FactoryGirl.create(:submission, hackathon_id: "1", user_id: "")

        get "https://api.vcap.me:3000/v1/submissions/#{@submission.id}?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission, hackathon_id: "1", user_id: ""), :format => :json
        expect(response.body).to eq @submission.to_json
        response.status.should eq(200)
      end

      it "should show the submission if not submitted && correct_user?" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon)
        @submission = FactoryGirl.create(:submission, hackathon_id: "1", user_id: "1", submitted_at: "")
        @submission1 = FactoryGirl.create(:submission, hackathon_id: "1", user_id: "2", submitted_at: "")

        if @submission.user_id == user.id
          get "https://api.vcap.me:3000/v1/submissions/#{@submission.id}?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission, hackathon_id: "1", user_id: "", submitted_at: ""), :format => :json
          response.status.should eq(200)
        else
          get "https://api.vcap.me:3000/v1/submissions/#{@submission1.id}?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission, hackathon_id: "1", user_id: "", submitted_at: ""), :format => :json
          response.status.should eq(401)
        end
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @hackathon = FactoryGirl.create(:hackathon)
      end

      context "with valid attributes" do
        it "creates a new submission" do
          expect{
            post "http://api.vcap.me:3000/v1/hackathons/#{@hackathon.id}/submissions?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission), :format => :json
          } .to change(Submission, :count).by(1)
        end

        it "creates a new submission, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/hackathons/#{@hackathon.id}/submissions?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission), :format => :json
          response.status.should eq(201)
        end
      end

      context "with invalid attributes" do
        it "creates a new submission" do
          expect{
            post "http://api.vcap.me:3000/v1/hackathons/#{@hackathon.id}/submissions?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission, title: ""), :format => :json
          } .to change(Submission, :count).by(0)
        end

        it "creates a new submission, making sure response is #201" do
          post "http://api.vcap.me:3000/v1/hackathons/#{@hackathon.id}/submissions?access_token=#{@token.token}", FactoryGirl.attributes_for(:submission, title: ""), :format => :json
          response.status.should eq(201)
        end
      end
    end

  end
end
