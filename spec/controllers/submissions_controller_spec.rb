require 'rails_helper'

RSpec.describe SubmissionsController, :type => :controller do

  login_user

  describe "GET #index" do
    it "renders the index template" do
      get :index, hackathon_id: FactoryGirl.create(:hackathon)
      response.should render_template 'index'
      response.status.should eq(200)
    end
  end

  describe "GET #tag" do
    before :each do
      @tag = create(:tag, name: 'test')
    end

    it "renders the tag template" do
      get :tag, tag: 'test'
      response.should render_template 'tag'
      response.status.should eq(200)
    end
  end

  describe "GET #show" do
    before :each do
      @submission = FactoryGirl.create(:submission, title: 'test')
    end

    it "renders the show template" do
      get :show, id: @submission
      response.should render_template 'show'
      response.status.should eq(200)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      @hackathon = FactoryGirl.create(:hackathon)
      get 'new', hackathon_id: @hackathon
      response.should render_template 'new'
      response.status.should eq(200)
    end
  end

  describe "POST #create" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    context "valid attributes" do
      it "creates a new submission" do
        expect{
          post :create, hackathon_id: @hackathon, submission: FactoryGirl.attributes_for(:submission)
        } .to change(Submission, :count).by(1)
      end

      it "redirects to hackathon_submissions_path" do
        post :create, hackathon_id: @hackathon, submission: FactoryGirl.attributes_for(:submission)
        response.should redirect_to hackathon_submissions_path(@hackathon)
      end
    end

    context "invalid attributes" do
      it "does not save the submission" do
        expect{
          post :create, hackathon_id: @hackathon, submission: FactoryGirl.attributes_for(:submission, title: nil)
        } .to_not change(Submission, :count)
      end

      it "renders the new template" do
        post :create, hackathon_id: @hackathon, submission: FactoryGirl.attributes_for(:submission, title: nil)
        response.should render_template 'new'
        response.status.should eq(200)
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @submission = FactoryGirl.create(:submission)
    end

    it "shows submission if correct_user" do
      if @submission.user_id == @current_user
        get :show, id: @submission, submission: FactoryGirl.attributes_for(:submission)
        response.should render_template 'edit'
        response.status.should eq(200)
      end
    end

    it "will redirect if not correct_user" do
      if @submission.user_id == @current_user
        get :show, id: FactoryGirl.create(:submission, user_id: nil)
        response.should redirect_to hackathon_submissions_path(@hackathon)
        flash[:notice].should == "Not authorized to edit this submission"
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @submission = FactoryGirl.create(:submission, user_id: "1")
    end

    context "valid attributes && correct_user" do
      it "located the requested @submission" do
        put :update, hackathon_id: @hackathon, id: @submission, submission: FactoryGirl.attributes_for(:submission)
        assigns(:submission).should eq(@submission)
      end

      it "changes @submission's attributes" do
        put :update, hackathon_id: @hackathon, id: @submission, submission: FactoryGirl.attributes_for(:submission, title: "Default")
        @submission.reload
        @submission.title.should eq("Default")
      end

      it "redirects to updated submission" do
        put :update, hackathon_id: @hackathon, id: @submission, submission: FactoryGirl.attributes_for(:submission)
        response.should redirect_to hackathon_submissions_path(@hackathon)
      end
    end

    context "invalid attributes && correct_user" do
      it "located the requested @submission" do
        put :update, hackathon_id: @hackathon, id: @submission, submission: FactoryGirl.attributes_for(:submission)
        assigns(:submission).should eq(@submission)
      end

      it "does not change @submission's attributes" do
        put :update, hackathon_id: @hackathon, id: @submission, submission: FactoryGirl.attributes_for(:profile, title: nil)
        @submission.reload
        @submission.title.should_not eq("Carl")
      end

      it "renders the edit template" do
        put :update, hackathon_id: @hackathon, id: @submission, submission: FactoryGirl.attributes_for(:submission, title: nil)
        response.should render_template 'edit'
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @submission = FactoryGirl.create(:submission, user_id: "1")
    end

    it "deletes the submission" do
      expect{
        delete :destroy, hackathon_id: @hackathon, id: @submission
      }.to change(Submission,:count).by(-1)
    end

    it "redirects to hackathon_submissions_path" do
      delete :destroy, hackathon_id: @hackathon, id: @submission
      response.should redirect_to hackathon_submissions_path(@hackathon)
    end
  end

end
