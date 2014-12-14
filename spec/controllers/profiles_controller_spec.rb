require 'rails_helper'
require 'factory_girl'

describe ProfilesController do

  describe "GET #index" do
    it "populates an array of the current_user's profiles" do
      profile == FactoryGirl.create(:profile)
      get :index
      assigns(:profile).should eq([profile])
    end

    it "renders the :index view" do
      sign_in :user, @user
      get :index
      response.should render_template :index
    end
  end
  describe "GET #show" do
  end
  describe "GET #new" do
  end
  describe "POST #create" do
  end
  describe "GET #index" do
  end
  describe "GET #index" do
  end
end
