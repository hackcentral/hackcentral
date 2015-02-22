require 'rails_helper'

RSpec.describe Admin::OrganizersController, :type => :controller do

  login_user

  describe "GET #index" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "renders the index template" do
      get :index, hackathon_id: @hackathon
      response.should render_template 'index'
      response.status.should eq(200)
    end
  end

  describe "GET #new" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "renders the new template" do
      get :new, hackathon_id: @hackathon
      response.should render_template 'new'
      response.status.should eq(200)
    end
  end
end