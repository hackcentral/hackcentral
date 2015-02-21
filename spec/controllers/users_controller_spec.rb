require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  login_user

  describe "GET #show" do
    it "renders the show template" do
      get :show, id: FactoryGirl.create(:user)
      response.should render_template 'show'
      response.status.should eq(200)
    end
  end

end
