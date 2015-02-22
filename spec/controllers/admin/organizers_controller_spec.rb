require 'rails_helper'

RSpec.describe Admin::OrganizersController, :type => :controller do

  login_user

  let!(:user) { create(:user, mlh: true) }

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

  describe "POST #create" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: "2")
    end

    context "valid attributes && user_id ==" do
      it "creates a new organizer" do
        if @hackathon.user_id == @current_user
          expect{
            post :create, hackathon_id: @hackathon, organizer: FactoryGirl.attributes_for(:organizer)
          } .to change(Organizer, :count).by(1)
        end
      end

      it "redirects to admin_hackathon_organizers_path" do
        if @hackathon.user_id == @current_user
          post :create, hackathon_id: @hackathon, organizer: FactoryGirl.attributes_for(:organizer)
          response.should redirect_to admin_hackathon_organizers_path
        end
      end
    end

    context "valid attributes && organizer ==" do
      it "creates a new organizer" do
        if user.organizers.where(hackathon_id: @hackathon)
          expect{
            post :create, hackathon_id: @hackathon, organizer: FactoryGirl.attributes_for(:organizer)
          } .to change(Organizer, :count).by(1)
        end
      end

      it "redirects to admin_hackathon_organizers_path" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :create, hackathon_id: @hackathon, organizer: FactoryGirl.attributes_for(:organizer)
          response.should redirect_to admin_hackathon_organizers_path
        end
      end
    end

    context "valid attributes && user_id !=" do
      it "will not create a new organizer" do
        if @hackathon1.user_id == @current_user
          expect{
            post :create, hackathon_id: @hackathon1, organizer: FactoryGirl.attributes_for(:organizer)
          } .to change(Organizer, :count).by(0)
        end
      end

      it "redirects to root_path" do
        if @hackathon1.user_id == @current_user
          post :create, hackathon_id: @hackathon1, organizer: FactoryGirl.attributes_for(:organizer)
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "will not create a new organizer" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          expect{
            post :create, hackathon_id: @hackathon1, organizer: FactoryGirl.attributes_for(:organizer)
          } .to change(Organizer, :count).by(0)
        end
      end

      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon)
        else
          post :create, hackathon_id: @hackathon1, organizer: FactoryGirl.attributes_for(:organizer)
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end
  end
end