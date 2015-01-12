require 'rails_helper'
require 'factory_girl'

describe HackathonsController, :type => :controller do

  login_user

  describe "GET #index" do
    it "renders the index template" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get 'new'
      response.should be_success
      response.should render_template 'new'
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new hackathon" do
        expect{
          post :create, hackathon: FactoryGirl.attributes_for(:hackathon)
        } .to change(Hackathon, :count).by(1)
      end

      it "redirects to new hackathon" do
        post :create, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should redirect_to hackathons_path
      end
    end
    context "with invalid attributes" do
      it "does not save the hackathon" do
        expect{
          post :create, hackathon: FactoryGirl.attributes_for(:hackathon, name: nil)
        } .to_not change(Hackathon, :count)
      end

      it "re-renders the new method" do
        post :create, hackathon: FactoryGirl.attributes_for(:hackathon, name: nil)
        response.should render_template :new
      end
    end
  end

  describe "GET #show" do
    it "render show template" do
      #get 'show', id: FactoryGirl.create(:hackathon)
      #response.should render_template 'show'
    end
  end
end
