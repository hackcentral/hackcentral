require "rails_helper"

describe Api::V1::SubmissionsController do

  let!(:user) { create(:user) }
  before { controller.stub(:current_user).and_return user }

  context "no access token" do

    it 'returns a 401 when users are not authenticated' do
      get :index, hackathon_id: create(:hackathon)
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      get :show, submission_id: '12345', hackathon_id: create(:hackathon)
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      post :create, hackathon_id: create(:hackathon)
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      put :update, submission_id: '12345', hackathon_id: create(:hackathon)
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      patch :update, submission_id: '12345', hackathon_id: create(:hackathon)
      expect(response.code).to eq "401"
    end
    it 'returns a 401 when users are not authenticated' do
      delete :destroy, submission_id: '12345', hackathon_id: create(:hackathon)
      expect(response.code).to eq "401"
    end
  end

  context "with access token" do
    describe 'GET #index' do
      it "should show all of hackathon's applications" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)

        get 'index', hackathon_id: create(:hackathon), :format => :json, :access_token => @token.token
        response.status.should eq(200)
      end
    end

    describe 'GET #show' do
      it "should show the submission" do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @submission = FactoryGirl.create(:submission)

        get 'show', hackathon_id: create(:hackathon), submission_id: @submission.id, submission: FactoryGirl.attributes_for(:submission), :format => :json, :access_token => @token.token
        response.status.should eq(200)
        assigns(:submission).should eq(@submission)
      end
    end

    describe 'POST #create' do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
      end

      context "with valid attributes" do
        it "creates a new submission" do
          expect{
            post :create, hackathon_id: create(:hackathon), submission: FactoryGirl.attributes_for(:submission), :format => :json, :access_token => @token.token
          } .to change(Submission, :count).by(1)
        end

        it "creates a new submission, making sure response is #201" do
          post :create, hackathon_id: create(:hackathon), submission: FactoryGirl.attributes_for(:submission), :format => :json, :access_token => @token.token
          response.status.should eq(201)
        end
      end

      context "with invalid attributes" do
        it "returns 422" do
          #post :create, hackathon_id: create(:hackathon), submission: FactoryGirl.attributes_for(:submission, title: nil), :format => :json, :access_token => @token.token
          #response.status.should eq(422)
        end
      end
    end

    describe "PUT #update" do
      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @submission = FactoryGirl.create(:submission)
      end

      context "valid attributes" do
        it "located the requested @submission" do
          put :update, hackathon_id: create(:hackathon), submission_id: @submission.id, submission: FactoryGirl.attributes_for(:submission), :format => :json, :access_token => @token.token
          assigns(:submission).should eq(@submission)
        end

        it "changes @submission's attributes" do
          put :update, hackathon_id: create(:hackathon), submission_id: @submission.id, submission: FactoryGirl.attributes_for(:submission, tagline: "lala"), :format => :json, :access_token => @token.token
          @submission.reload
          @submission.tagline.should eq("lala")
        end

        it "sends a 200 if updated submission if correct_user" do
          if @submission.user_id == user.id
            put :update, hackathon_id: create(:hackathon), submission_id: @submission.id, submission: FactoryGirl.attributes_for(:submission), :format => :json, :access_token => @token.token
            response.status.should eq(200)
          else
          end
        end
      end

      context "invalid attributes" do
        it "located the requested @submission" do
          put :update, hackathon_id: create(:hackathon), submission_id: @submission.id, submission: FactoryGirl.attributes_for(:submission), :format => :json, :access_token => @token.token
          assigns(:submission).should eq(@submission)
        end

        it "does not change @submission's attributes" do
          put :update, hackathon_id: create(:hackathon), submission_id: @submission.id, submission: FactoryGirl.attributes_for(:submission, tagline: nil), :format => :json, :access_token => @token.token
          @submission.reload
          @submission.tagline.should_not eq(nil)
        end

        it "makes sure only correct user can update" do
          if @submission.user_id == user.id
          else
            response.status.should eq(401)
          end
        end
      end
    end

    describe "DELETE #destroy" do

      before :each do
        @oauth_application = FactoryGirl.build(:oauth_application)
        @token = Doorkeeper::AccessToken.create!(:application_id => @oauth_application.id, :resource_owner_id => user.id)
        @submission = FactoryGirl.create(:submission)
      end

      it "deletes the submission" do
        if @submission.user_id == user.id
          expect{
            delete :destroy, hackathon_id: create(:hackathon), submission_id: @submission.id, :format => :json, :access_token => @token.token
          }.to change(Submission,:count).by(-1)
        else
          response.status.should eq(401)
        end
      end

      it "responds with 204" do
        if @submission.user_id == user.id
          delete :destroy, hackathon_id: create(:hackathon), submission_id: @submission.id, :format => :json, :access_token => @token.token
          response.status.should eq(204)
        else
          response.status.should eq(401)
        end
      end
    end
  end
end
