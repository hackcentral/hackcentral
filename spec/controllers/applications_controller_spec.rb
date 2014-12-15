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
    it "redirects bc unauthorized" do
      get 'show', id: FactoryGirl.create(:application)
      response.should redirect_to applications_path
      flash[:notice].should == "Not authorized to edit this application"
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
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new profile" do
        expect{
          post :create, application: FactoryGirl.attributes_for(:application)
        } .to change(Application, :count).by(1)
      end

      it "redirects to new profile" do
        post :create, application: FactoryGirl.attributes_for(:application)
        response.should redirect_to Application.last
      end
    end

    context "with invalid attributes" do
      it "does not save the profile" do
        expect{
          post :create, application: FactoryGirl.attributes_for(:application, reimbursement_needed: nil)
        } .to_not change(Profile, :count)
      end
    end
  end

  describe "GET #edit" do
    it "redirects bc unauthorized" do
      get 'edit', id: FactoryGirl.create(:application)
      response.should redirect_to applications_path
      flash[:notice].should == "Not authorized to edit this application"
    end
  end

  describe "PUT #update" do
    it "redirects bc unauthorized" do
      put 'update', id: FactoryGirl.create(:application)
      response.should redirect_to applications_path
      flash[:notice].should == "Not authorized to edit this application"
    end
  end

  describe "DELETE #destroy" do
    it "redirects bc unauthorized" do
      delete 'destroy', id: FactoryGirl.create(:application)
        response.should redirect_to applications_path
        flash[:notice].should == "Not authorized to edit this application"
    end
  end
end
