require 'rails_helper'

RSpec.describe "Organizers", :type => :request do
  describe "GET /organizers" do
    it "works! (now write some real specs)" do
      get organizers_path
      expect(response.status).to be(200)
    end
  end
end
