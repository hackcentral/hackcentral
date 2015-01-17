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

    before(:each) do
      @profile = FactoryGirl.create(:profile)
    end

    it "runs through the correct_user method" do
      if @profile.user_id == @current_user
        get 'show', id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should render_template 'show'
      else
        get 'show', id: FactoryGirl.create(:profile, user_id: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get 'new'
      response.should render_template 'new'
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
    before(:each) do
      @profile = FactoryGirl.create(:profile)
    end

    it "runs through the correct_user method" do
      if @profile.user_id == @current_user
        get 'edit', id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should render_template 'show'
      else
        get 'edit', id: FactoryGirl.create(:profile, user_id: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end
    end
  end

  describe "PUT #update" do
    before(:each) do
      @profile = FactoryGirl.create(:profile)
    end

    context "valid attributes" do
      it "located the requested @profile" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        assigns(:profile).should eq(@profile)
      end

      it "changes @profile's attributes" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: "Default")
        @profile.reload
        @profile.name.should eq("Default")
      end

      it "redirects to updated profile" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should redirect_to profile_url
      end
    end

    context "invalid attributes" do
      it "located the requested @profile" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        assigns(:profile).should eq(@profile)
      end

      it "does not change @profile's attributes" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil)
        @profile.reload
        @profile.name.should_not eq("Carl")
      end

      it "re-renders the edit method" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: "Default", school_grad: nil)
        response.should render_template 'edit'
      end
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @profile = FactoryGirl.create(:profile)
    end

    it "deletes the profile" do
      expect{
        delete :destroy, id: @profile
      }.to change(Profile,:count).by(-1)
    end

    it "redirects to profiles#index" do
      delete :destroy, id: @profile
      response.should redirect_to profiles_path
    end
  end
end
