require 'rails_helper'

RSpec.describe PagesController, :type => :controller do

  describe "GET #home" do
    it "renders the home template" do
      get :home
      response.should render_template 'home'
      response.status.should eq(200)
    end
  end

  describe "GET #about" do
    it "renders the about template" do
      get :about
      response.should render_template 'about'
      response.status.should eq(200)
    end
  end

  describe "GET #contact" do
    it "renders the contact template" do
      get :contact
      response.should render_template 'contact'
      response.status.should eq(200)
    end
  end

end
