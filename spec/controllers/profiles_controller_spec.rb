require 'rails_helper'
require 'factory_girl'

describe ProfilesController, :type => :controller do

    login_user

  describe "GET #index" do
    it "renders the index template" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET #show" do
    it "redirects bc unauthorized" do
      get 'show', id: FactoryGirl.create(:profile)
      response.should redirect_to profiles_path
      flash[:notice].should == "Not authorized to edit this profile"
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new profile" do
        expect{
          post :create, profile: FactoryGirl.attributes_for(:profile)
        } .to change(Profile, :count).by(1)
      end

      it "redirects to new profile" do
        post :create, profile: FactoryGirl.attributes_for(:profile)
        response.should redirect_to Profile.last
      end
    end

    context "with invalid attributes" do
      it "does not save the profile" do
        expect{
          post :create, profile: FactoryGirl.attributes_for(:profile, name: nil)
        } .to_not change(Profile, :count)
      end

      it "re-renders the new method" do
        post :create, profile: FactoryGirl.attributes_for(:profile, name: nil)
        response.should render_template :new
      end
    end
  end

  describe "GET #edit" do
    it "redirects bc unauthorized" do
      get 'edit', id: FactoryGirl.create(:profile)
      response.should redirect_to profiles_path
      flash[:notice].should == "Not authorized to edit this profile"
    end
  end

  describe "PUT #update" do
    it "redirects bc unauthorized" do
      put 'update', id: FactoryGirl.create(:profile)
      response.should redirect_to profiles_path
      flash[:notice].should == "Not authorized to edit this profile"
    end
  end

  describe "DELETE #destroy" do
    @profile == FactoryGirl.create(:profile)

    it "redirects bc unauthorized" do
      delete 'destroy', id: FactoryGirl.create(:profile)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
    end
  end
end
