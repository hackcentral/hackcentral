require 'rails_helper'
require 'factory_girl'

describe Admin::HackathonsController, :type => :controller do

  login_user

  describe "GET #edit" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "renders edit template if correct_user" do
      if @hackathon.user_id == @current_user
        get 'edit', id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should render_template 'edit'
      else
      end
    end

    it "will redirect if not correct_user" do
      if @hackathon.user_id != @current_user
        get 'edit', id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, user_id: '3')
        should respond_with(200)
      end
    end
  end

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
        response.should redirect_to admin_hackathon_path
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
        #put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
        #response.should be_success
      end
    end

  end

  describe "DELETE #destroy" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "deletes the hackathon if correct_user" do
      if @hackathon.user_id == @current_user
        expect{
          delete :destroy, id: @hackathon
        }.to change(Hackathon,:count).by(-1)
      else
      end
    end

    it "will redirect if not correct_user" do
      if @hackathon.user_id != @current_user
        #get 'edit', id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, user_id: nil)
        #response.should redirect_to root_path
        #flash[:notice].should == "Not authorized"
      end
    end

    it "deletes the hackathon" do
    end

    it "redirects to hackathons#index" do
      delete :destroy, id: @hackathon
      response.should redirect_to root_path
    end
  end
end