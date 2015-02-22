require 'rails_helper'

describe Admin::HackathonsController, :type => :controller do

  login_user

  let!(:user) { create(:user, mlh: true) }

  describe "GET #index" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "renders the index template" do
      get :index, id: @hackathon
      response.should render_template 'index'
      response.status.should eq(200)
    end
  end

  describe "GET #edit" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: '3')
    end

    it "renders edit template if correct_user" do
      if @hackathon.user_id == @current_user
        get :edit, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should render_template 'edit'
        response.status.should eq(200)
      end
    end

    it "will redirect if not correct_user" do
      if @hackathon.user_id != @current_user
        get :edit, id: @hackathon1, hackathon: FactoryGirl.attributes_for(:hackathon, user_id: '3')
        response.should redirect_to root_path
        flash[:notice].should == "Not authorized"
      end
    end

    it "renders edit template if organizer" do
      if user.organizers.where(hackathon_id: @hackathon)
        get :edit, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should render_template 'edit'
        response.status.should eq(200)
      else
        get :edit, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        response.should redirect_to root_path
        flash[:notice].should == "Not authorized"
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: '3')
    end

    context "valid attributes && correct_user" do
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

    context "valid attributes && organizer" do
      it "located the request @hackathon" do
        if user.organizers.where(hackathon_id: @hackathon)
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
          assigns(:hackathon).should eq(@hackathon)
        end
      end

      it "changes @hackathon's attributes" do
        if user.organizers.where(hackathon_id: @hackathon)
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps")
          @hackathon.reload
          @hackathon.name.should eq("TestApps")
        end
      end

      it "redirects to updated hackathon" do
        if user.organizers.where(hackathon_id: @hackathon)
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
          response.should redirect_to admin_hackathon_path
        end
      end
    end

    context "invalid attributes && correct_user" do
      it "located the requested @hackathon" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        assigns(:hackathon).should eq(@hackathon)
      end

      it "does not change @hackathon's attributes" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
        @hackathon.reload
        @hackathon.subdomain.should_not eq("test")
      end

      it "renders the edit template" do
        put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
        response.should render_template 'edit'
      end
    end

    context "invalid attributes && organizer" do
      it "located the requested @hackathon" do
        if user.organizers.where(hackathon_id: @hackathon)
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
          assigns(:hackathon).should eq(@hackathon)
        end
      end

      it "does not change @hackathon's attributes" do
        if user.organizers.where(hackathon_id: @hackathon)
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
          @hackathon.reload
          @hackathon.subdomain.should_not eq("test")
        end
      end

      it "renders the edit template" do
        if user.organizers.where(hackathon_id: @hackathon)
          put :update, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon, name: "TestApps", subdomain: nil)
          response.should render_template 'edit'
        end
      end
    end

    context "valid attributes && user_id !=" do
      it "redirects to root_path" do
        put :update, id: @hackathon1, hackathon: FactoryGirl.attributes_for(:hackathon, user_id: "3")
        if @hackathon.user_id != @current_user
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "redirects to root_path" do
        put :update, id: @hackathon1, hackathon: FactoryGirl.attributes_for(:hackathon, user_id: "3")
        if user.organizers.where(hackathon_id: @hackathon)
        else
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

  end

  describe "DELETE #destroy" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    context "correct_user" do
      it "deletes the hackathon" do
        if @hackathon.user_id == @current_user
          expect{
            delete :destroy, id: @hackathon
          }.to change(Hackathon,:count).by(-1)
        else
        end
      end

      it "redirects to root_path" do
        if @hackathon.user_id == @current_user
          delete :destroy, id: @hackathon
          response.should redirect_to root_path
        else
        end
      end
    end

    context "not correct_user" do
    end
  end

  describe "GET #checkin_index" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "renders the checkin_index template" do
      get :checkin_index, id: @hackathon
      response.should render_template 'checkin_index'
    end
  end

  describe "POST #checkin" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @application = FactoryGirl.create(:application)
    end

    context "valid attributes" do
      it "changes @application's attributes" do
        #post :checkin, id: @hackathon, application_id: FactoryGirl.attributes_for(:application).id
        #@application = FactoryGirl.attributes_for(:application, accepted: true)
        #@application.reload
        #@application.accepted.should eq(true)
      end

      it "redirects" do
        #put :checkin, id: @hackathon, hackathon: FactoryGirl.attributes_for(:hackathon)
        #response.should redirect_to admin_hackathon_tickets_path(@application.hackathon)
      end
    end
  end

end