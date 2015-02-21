require 'rails_helper'

RSpec.describe Admin::DashboardsController, :type => :controller do

  describe "GET #index" do

    login_user

    it "renders the index template" do
      get :index
      response.should render_template 'index'
      response.status.should eq(200)
    end
  end

  describe "GET #mlh_root" do

    login_mlh

    it "renders the mlh_root template" do
      get :mlh_root
      response.should render_template 'mlh_root'
      response.status.should eq(200)
    end
  end

  describe "POST #mlh_sanction" do
    login_mlh

    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    context "valid attributes" do
      it "sanctions hackathon" do
        post :mlh_sanction, hackathon_id: @hackathon
        @hackathon.reload
        @hackathon.mlh_sanctioned.should eq(true)
      end

      it "redirects to admin_mlh_path" do
        post :mlh_sanction, hackathon_id: @hackathon
        response.should redirect_to admin_mlh_path
        flash[:notice].should == "Sanctioning complete!"
      end
    end
  end

  describe "POST #mlh_unsanction" do
    login_mlh

    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    context "valid attributes" do
      it "unsanctions hackathon" do
        post :mlh_unsanction, hackathon_id: @hackathon
        @hackathon.reload
        @hackathon.mlh_sanctioned.should eq(false)
      end

      it "redirects to admin_mlh_path" do
        post :mlh_unsanction, hackathon_id: @hackathon
        response.should redirect_to admin_mlh_path
        flash[:notice].should == "Unsanctioning complete!"
      end
    end
  end

end
