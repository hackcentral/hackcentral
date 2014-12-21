require "rails_helper"

RSpec.describe OrganizersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hackathons/1/organizers").to route_to("organizers#index")
    end

    it "routes to #new" do
      expect(:get => "/hackathons/1/organizers/new").to route_to("organizers#new")
    end

    it "routes to #destroy" do
      expect(:delete => "/hackathons/1/organizers/1").to route_to("organizers#destroy", :id => "1")
    end

  end
end
