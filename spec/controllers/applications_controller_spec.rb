require 'rails_helper'
require 'factory_girl'

describe ApplicationsController, :type => :controller do

  login_user

  describe "GET #index" do
    it "renders the index template" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET #show" do

    before(:each) do
      @application = FactoryGirl.create(:application)
    end

    it "runs through the correct_user method" do
      if @application.user_id == @current_user
        get 'show', id: @application, application: FactoryGirl.attributes_for(:application)
        response.should render_template 'show'
      else
        get 'show', id: FactoryGirl.create(:application, user_id: nil)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end
    end
  end

  describe "GET #new" do
    it "redirects bc no hackathon_id param" do
      get 'new'
      response.should redirect_to applications_path
      flash[:notice].should == "An application needs to have a hackathon_id."
    end

    it "renders new template" do
      #controller.params[:hackathon_id].should_not be_nil
      #controller.params[:hackathon_id].should eql { Faker::Number.number(4) }
      #response.should render_template 'new'
      # http://stackoverflow.com/questions/13710889/how-do-i-pass-a-params-parameter-into-an-rspec-controller-test
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new application" do
        expect{
          post :create, application: FactoryGirl.attributes_for(:application)
        } .to change(Application, :count).by(1)
      end

      it "redirects to new profile" do
        post :create, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to Application.last
      end
    end
  end

  describe "GET #edit" do
    before(:each) do
      @application = FactoryGirl.create(:application)
    end

    it "runs through the correct_user method" do
      if @application.user_id == @current_user
        get 'edit', id: @application, application: FactoryGirl.attributes_for(:application)
        response.should render_template 'show'
      else
        get 'edit', id: FactoryGirl.create(:application, user_id: nil)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @application = FactoryGirl.create(:application)
    end

    context "valid attributes" do
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

    context "invalid attributes" do
      it "located the requested @application" do
        put :update, id: @application, application: FactoryGirl.attributes_for(:application)
        assigns(:application).should eq(@application)
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

    it "redirects to applications#index" do
      delete :destroy, id: @application
      response.should redirect_to applications_path
    end
  end
end
