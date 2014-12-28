require 'rails_helper'

RSpec.describe HackathonExtrasController, :type => :controller do

  describe "GET participants" do
    it "returns http success" do
      #get :participants
      #expect(response).to be_success
    end
  end

  describe "GET rules" do
    it "returns http success" do
      get :rules
      expect(response).to be_success
    end
  end

end
