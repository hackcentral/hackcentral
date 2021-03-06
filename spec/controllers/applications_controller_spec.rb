require 'rails_helper'

RSpec.describe ApplicationsController, :type => :controller do

  login_user

  describe "GET #index" do
    it "renders the index template" do
      get :index
      response.should render_template 'index'
      response.status.should eq(200)
    end
  end

  describe "GET #show" do
    before :each do
      @application = FactoryGirl.create(:application)
    end

    it "shows application if correct_user" do
      if @application.user_id == @current_user
        get :show, id: @application
        response.should render_template 'show'
        response.status.should eq(200)
      end
    end

    it "will redirect if not correct_user" do
      if @application.user_id != @current_user
        get :show, id: FactoryGirl.create(:application, user_id: nil)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end
    end
  end

  describe "GET #new" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "redirects if no params[:hackathon_id]" do
      get :new
      response.should redirect_to applications_path
      flash[:notice].should == "An application needs to have a hackathon_id."
    end

    it "renders the new template" do
      get :new, :hackathon_id => @hackathon
      response.should render_template 'new'
      response.status.should eq(200)
    end

    it 'redirects to root_path if Hackathon is fake' do
      get :new, :hackathon_id => "90"
      response.should redirect_to root_path
      flash[:notice].should == "This hackathon doesn't exist."
    end
  end

  describe "POST #create" do
    context "valid attributes" do
      it "creates a new application" do
        @hackathon = FactoryGirl.create(:hackathon)
        expect{
          post :create, hackathon_id: @hackathon, application: FactoryGirl.attributes_for(:application)
        } .to change(Application, :count).by(1)
      end

      it "redirects to new application" do
        @hackathon = FactoryGirl.create(:hackathon)
        post :create, hackathon_id: @hackathon, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to Application.last
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @application = FactoryGirl.create(:application)
    end

    it "shows application if correct_user" do
      if @application.user_id == @current_user
        get :edit, id: @application, application: FactoryGirl.attributes_for(:application)
        response.should render_template 'edit'
        response.status.should eq(200)
      else
      end
    end

    it "will redirect if not correct_user" do
      if @application.user_id != @current_user
        get :edit, id: FactoryGirl.create(:application, user_id: nil)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end
    end
  end

  describe "POST #rsvp_yes" do
    before :each do
      @application = FactoryGirl.create(:application, accepted: true)
    end

    context "valid attributes && correct_user" do
      it "located the requested @application" do
        post :rsvp_yes, id: @application, application: FactoryGirl.attributes_for(:application)
        assigns(:application).should eq(@application)
      end

      it "changes @application's attributes" do
        post :rsvp_yes, id: @application, application: FactoryGirl.attributes_for(:application)
        @application.reload
        @application.rsvp.should eq(true)
      end

      it "redirects to updated application" do
        post :rsvp_yes, id: @application, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to application_path
        flash[:notice].should == "You have RSVPed yes."
      end
    end
  end

  describe "POST #rsvp_no" do
    before :each do
      @application = FactoryGirl.create(:application, accepted: true)
    end

    context "valid attributes && correct_user" do
      it "located the requested @application" do
        post :rsvp_no, id: @application, application: FactoryGirl.attributes_for(:application)
        assigns(:application).should eq(@application)
      end

      it "changes @application's attributes" do
        post :rsvp_no, id: @application, application: FactoryGirl.attributes_for(:application)
        @application.reload
        @application.rsvp.should eq(false)
      end

      it "redirects to updated application" do
        post :rsvp_no, id: @application, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to application_path
        flash[:notice].should == "You have RSVPed no."
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @application = FactoryGirl.create(:application)
    end

    context "valid attributes && correct_user" do
      it "located the requested @application" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application)
        assigns(:application).should eq(@application)
      end

      it "changes @application's attributes" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application, reimbursement_needed: true)
        @application.reload
        @application.reimbursement_needed.should eq(true)
      end

      it "redirects to updated application" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to application_url
      end
    end

    context "valid attributes && not correct_user" do
      login_user

      it "will redirect if not correct_user" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end

      it "will redirect if not correct_user" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application, reimbursement_needed: true)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end

      it "will redirect if not correct_user" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @application = FactoryGirl.create(:application)
    end

    it "deletes the application" do
      expect{
        delete :destroy, id: @application
      }.to change(Application,:count).by(-1)
    end

    it "redirects to applications_path" do
      delete :destroy, id: @application
      response.should redirect_to applications_path
    end
  end
end
