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
    it "renders the show template and shows a profile" do
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
  end
end
