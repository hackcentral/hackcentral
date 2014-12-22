require 'rails_helper'
require 'factory_girl'

describe HackathonsController, :type => :controller do

  describe "GET #index" do
    it "renders the index template" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET #show" do
    it "render show template" do
      get 'show', id: FactoryGirl.create(:hackathon)
      response.should render_template 'show'
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

  #describe "GET #edit" do
    #it "render edit template" do
      #get 'edit', id: FactoryGirl.create(:hackathon)
      #response.should render_template 'edit'
    #end
  #end

  describe "PUT #update" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    context "valid attributes" do
      it "located the requested @hackathon" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        assigns(:hackathon).should eq(@hackathon)
      end

      it "changes @hackathon's attributes" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps")
        @hackathon.reload
        @hackathon.name.should eq("TestApps")
      end

      it "redirects to updated hackathon" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should redirect_to hackathons_path
      end
    end

    context "invalid attributes" do
      it "located the requested @hackathon" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        assigns(:hackathon).should eq(@hackathon)
      end

      it "does not change @hackathon's attributes" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
        @hackathon.reload
        @hackathon.name.should_not eq("TestApps")
        @hackathon.subdomain.should eq("testapps")
      end

      it "re-renders the edit method" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
        response.should render_template 'edit'
      end
    end

  end

  describe "DELETE #destroy" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "deletes the hackathon" do
      expect{
        delete :destroy, id: @hackathon
      }.to change(Hackathon,:count).by(-1)
    end

    it "redirects to hackathons#index" do
      delete :destroy, id: @hackathon
      response.should redirect_to hackathons_path
    end
  end
end
