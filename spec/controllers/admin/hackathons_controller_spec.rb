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
        if @hackathon1.user_id != @current_user
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "redirects to root_path" do
        put :update, id: @hackathon1, hackathon: FactoryGirl.attributes_for(:hackathon, user_id: "3")
        if user.organizers.where(hackathon_id: @hackathon1)
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
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: '3')
    end

    context "valid attributes && correct_user" do
      it "deletes the hackathon" do
        if @hackathon.user_id == @current_user
          expect{
            delete :destroy, id: @hackathon
          }.to change(Hackathon,:count).by(-1)
        end
      end

      it "redirects to root_path" do
        if @hackathon.user_id == @current_user
          delete :destroy, id: @hackathon
          response.should redirect_to root_path
        end
      end
    end

    context "valid attributes && organizer" do
      it "deletes the hackathon" do
        if user.organizers.where(hackathon_id: @hackathon)
          expect{
            delete :destroy, id: @hackathon
          }.to change(Hackathon,:count).by(-1)
        end
      end

      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon)
          delete :destroy, id: @hackathon
          response.should redirect_to root_path
        end
      end
    end

    context "valid attributes && correct_user !=" do
      it "will not delete hackathon" do
        if @hackathon1.user_id == @current_user
        else
          expect{
            delete :destroy, id: @hackathon1
          }.to change(Hackathon,:count).by(0)
        end
      end

      it "redirects to root_path" do
        if @hackathon1.user_id == @current_user
        else
          delete :destroy, id: @hackathon1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "will not delete hackathon" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          expect{
            delete :destroy, id: @hackathon1
          }.to change(Hackathon,:count).by(0)
        end
      end

      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          delete :destroy, id: @hackathon1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end
  end

  describe "GET #checkin_index" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    it "renders the checkin_index template" do
      get :checkin_index, id: @hackathon
      response.should render_template 'checkin_index'
      response.status.should eq(200)
    end
  end

  describe "POST #checkin" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: "2")
      @application = FactoryGirl.create(:application, hackathon_id: "1")
      @application1 = FactoryGirl.create(:application, hackathon_id: "2")
    end

    context "valid attributes && correct_user" do
      it "checks in application" do
        if @hackathon.user_id == @current_user
          post :checkin, id: @hackathon, application_id: @application
          @application.reload
          @application.checked_in.should eq(true)
        end
      end

      it "redirects to admin_hackathon_tickets_path" do
        if @hackathon.user_id == @current_user
          post :checkin, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_tickets_path
          flash[:notice].should == "Checkin complete!"
        end
      end
    end

    context "valid attributes && organizer" do
      it "checks in application" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :checkin, id: @hackathon, application_id: @application
          @application.reload
          @application.checked_in.should eq(true)
        end
      end

      it "redirects to admin_hackathon_tickets_path" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :checkin, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_tickets_path
          flash[:notice].should == "Checkin complete!"
        end
      end
    end

    context "valid attributes && correct_user !=" do
      it "redirects to root_path" do
        if @hackathon1.user_id == @current_user
        else
          post :checkin, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          post :checkin, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end
  end

  describe "POST #uncheckin" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: "2")
      @application = FactoryGirl.create(:application, hackathon_id: "1")
      @application1 = FactoryGirl.create(:application, hackathon_id: "2")
    end

    context "valid attributes && correct_user" do
      it "unchecks in application" do
        if @hackathon.user_id == @current_user
          post :uncheckin, id: @hackathon, application_id: @application
          @application.reload
          @application.checked_in.should eq(false)
        end
      end

      it "redirects to admin_hackathon_tickets_path" do
        if @hackathon.user_id == @current_user
          post :uncheckin, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_tickets_path
          flash[:notice].should == "Un-checkin complete!"
        end
      end
    end

    context "valid attributes && organizer" do
      it "unchecks in application" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :uncheckin, id: @hackathon, application_id: @application
          @application.reload
          @application.checked_in.should eq(false)
        end
      end

      it "redirects to admin_hackathon_tickets_path" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :uncheckin, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_tickets_path
          flash[:notice].should == "Un-checkin complete!"
        end
      end
    end

    context "valid attributes && correct_user !=" do
      it "redirects to root_path" do
        if @hackathon1.user_id == @current_user
        else
          post :uncheckin, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          post :uncheckin, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end
  end

  describe "GET #application_index" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
    end

    context "accepted = t" do
      it "renders the application_index template" do
        get :application_index, id: @hackathon, accepted: "t"
        response.should render_template 'application_index'
        response.status.should eq(200)
      end
    end

    context "accepted = f" do
      it "renders the application_index template" do
        get :application_index, id: @hackathon, accepted: "f"
        response.should render_template 'application_index'
        response.status.should eq(200)
      end
    end

    context "accepted = nil" do
      it "renders the application_index template" do
        get :application_index, id: @hackathon
        response.should render_template 'application_index'
        response.status.should eq(200)
      end
    end
  end

  describe "POST #application_accept" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: "2")
      @application = FactoryGirl.create(:application, hackathon_id: "1")
      @application1 = FactoryGirl.create(:application, hackathon_id: "2")
    end

    context "valid attributes && correct_user" do
      it "accept application" do
        if @hackathon.user_id == @current_user
          post :application_accept, id: @hackathon, application_id: @application
          @application.reload
          @application.accepted.should eq(true)
        end
      end

      it "redirects to admin_hackathon_applications_path" do
        if @hackathon.user_id == @current_user
          post :application_accept, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_applications_path
          flash[:notice].should == "Acceptance complete!"
        end
      end
    end

    context "valid attributes && organizer" do
      it "accept application" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :application_accept, id: @hackathon, application_id: @application
          @application.reload
          @application.accepted.should eq(true)
        end
      end

      it "redirects to admin_hackathon_tickets_path" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :application_accept, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_applications_path
          flash[:notice].should == "Acceptance complete!"
        end
      end
    end

    context "valid attributes && correct_user !=" do
      it "redirects to root_path" do
        if @hackathon1.user_id == @current_user
        else
          post :application_accept, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          post :application_accept, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end
  end

  describe "POST #application_unaccept" do
    before :each do
      @hackathon = FactoryGirl.create(:hackathon)
      @hackathon1 = FactoryGirl.create(:hackathon, user_id: "2")
      @application = FactoryGirl.create(:application, hackathon_id: "1")
      @application1 = FactoryGirl.create(:application, hackathon_id: "2")
    end

    context "valid attributes && correct_user" do
      it "unaccept application" do
        if @hackathon.user_id == @current_user
          post :application_unaccept, id: @hackathon, application_id: @application
          @application.reload
          @application.accepted.should eq(false)
        end
      end

      it "redirects to admin_hackathon_applications_path" do
        if @hackathon.user_id == @current_user
          post :application_unaccept, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_applications_path
          flash[:notice].should == "Acceptance complete!"
        end
      end
    end

    context "valid attributes && organizer" do
      it "accept application" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :application_unaccept, id: @hackathon, application_id: @application
          @application.reload
          @application.accepted.should eq(false)
        end
      end

      it "redirects to admin_hackathon_tickets_path" do
        if user.organizers.where(hackathon_id: @hackathon)
          post :application_unaccept, id: @hackathon, application_id: @application
          response.should redirect_to admin_hackathon_applications_path
          flash[:notice].should == "Unacceptance complete!"
        end
      end
    end

    context "valid attributes && correct_user !=" do
      it "redirects to root_path" do
        if @hackathon1.user_id == @current_user
        else
          post :application_unaccept, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end

    context "valid attributes && organizer !=" do
      it "redirects to root_path" do
        if user.organizers.where(hackathon_id: @hackathon1)
        else
          post :application_unaccept, id: @hackathon1, application_id: @application1
          response.should redirect_to root_path
          flash[:notice].should == "Not authorized"
        end
      end
    end
  end

end