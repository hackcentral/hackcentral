require 'rails_helper'

RSpec.describe HackathonsController, :type => :controller do

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
      @hackathon = FactoryGirl.create(:hackathon)
      @request.host = "#{@hackathon.subdomain}.example.com"
    end

    it "renders the show template" do
      get :show
      response.should render_template 'show'
      response.status.should eq(200)
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
      it "creates a new hackathon" do
        expect{
          post :create, hackathon: FactoryGirl.attributes_for(:hackathon)
        } .to change(Hackathon, :count).by(1)
      end

      it "redirects to hackathons_path" do
        post :create, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should redirect_to hackathons_path
      end
    end
    context "invalid attributes" do
      it "does not save the hackathon" do
        expect{
          post :create, hackathon: FactoryGirl.attributes_for(:hackathon, name: nil)
        } .to change(Hackathon, :count).by(0)
      end

      it "renders the new template" do
        post :create, hackathon: FactoryGirl.attributes_for(:hackathon, name: nil)
        response.should render_template :new
      end
    end
  end
end
