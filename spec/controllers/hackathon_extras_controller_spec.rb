require 'rails_helper'

RSpec.describe HackathonExtrasController, :type => :controller do

  describe "GET #participants" do
    it "renders the participants template" do
      @hackathon = FactoryGirl.create(:hackathon)
      @request.host = "#{@hackathon.subdomain}.example.com"

      get :participants
      response.should render_template 'participants'
      response.status.should eq(200)
    end
  end

  describe "GET #rules" do
    it "renders the rules template" do
      @hackathon = FactoryGirl.create(:hackathon)
      @request.host = "#{@hackathon.subdomain}.example.com"

      get :rules
      response.should render_template 'rules'
      response.status.should eq(200)
    end
  end

end
