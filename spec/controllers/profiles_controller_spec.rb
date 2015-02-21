require 'rails_helper'

RSpec.describe ProfilesController, :type => :controller do

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
      @profile = FactoryGirl.create(:profile)
    end

    it "shows profile if correct_user" do
      if @profile.user_id == @current_user
        get :show, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should render_template 'show'
        response.status.should eq(200)
      end
    end

    it "will redirect if not correct_user" do
      if @profile.user_id == @current_user
        get :show, id: FactoryGirl.create(:profile, user_id: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      response.should render_template 'new'
      response.status.should eq(200)
    end
  end

  describe "POST #create" do
    context "valid attributes" do
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

    context "invalid attributes" do
      it "does not save the profile" do
        expect{
          post :create, profile: FactoryGirl.attributes_for(:profile, name: nil)
        } .to_not change(Profile, :count)
      end

      it "renders the new template" do
        post :create, profile: FactoryGirl.attributes_for(:profile, name: nil)
        response.should render_template 'new'
        response.status.should eq(200)
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @profile = FactoryGirl.create(:profile)
    end

    it "shows profile if correct_user" do
      if @profile.user_id == @current_user
        get :show, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should render_template 'edit'
        response.status.should eq(200)
      end
    end

    it "will redirect if not correct_user" do
      if @profile.user_id == @current_user
        get :show, id: FactoryGirl.create(:profile, user_id: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @profile = FactoryGirl.create(:profile)
    end

    context "valid attributes && correct_user" do
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

    context "invalid attributes && correct_user" do
      it "located the requested @profile" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        assigns(:profile).should eq(@profile)
      end

      it "does not change @profile's attributes" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil)
        @profile.reload
        @profile.name.should_not eq("Carl")
      end

      it "renders the edit template" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil)
        response.should render_template 'edit'
      end
    end

    context "valid attributes && not correct_user" do
      login_user

      it "will redirect if not correct_user" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end

      it "will redirect if not correct_user" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: "Default")
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end

      it "will redirect if not correct_user" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end
    end

    context "invalid attributes && not correct_user" do
      login_user

      it "will redirect if not correct_user" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end

      it "will redirect if not correct_user" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end

      it "will redirect if not correct_user" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:profile, name: nil)
        response.should redirect_to profiles_path
        flash[:notice].should == "Not authorized to edit this profile"
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @profile = FactoryGirl.create(:profile)
    end

    it "deletes the profile" do
      expect{
        delete :destroy, id: @profile
      }.to change(Profile,:count).by(-1)
    end

    it "redirects to profiles_path" do
      delete :destroy, id: @profile
      response.should redirect_to profiles_path
    end
  end
end
