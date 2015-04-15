class Admin::HackathonsController < ApplicationController
  before_action :set_hackathon
  before_action :authenticate_user!
  before_action :is_organizer

  # Root
    def index
      @organizers = Organizer.all
    end

  # Editing
    def edit
    end

    # PATCH/PUT /hackathons/1
    # PATCH/PUT /hackathons/1.json
    def update
      respond_to do |format|
        if @hackathon.update(hackathon_params)
          format.html { redirect_to admin_hackathon_path(@hackathon), notice: 'Hackathon was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    # DELETE /hackathons/1
    # DELETE /hackathons/1.json
    def destroy
      @hackathon.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Hackathon was successfully destroyed.' }
      end
    end

  # Check in
    def checkin_index
      @applications = Application.where(hackathon_id: @hackathon, accepted: true).all
    end

    def checkin
      @application = Application.find_by_id(params[:application_id])
        if @application.hackathon_id != @hackathon.id
          redirect_to root_path, notice: "Not authorized"
        end
      @application.update_attribute :checked_in, true
      redirect_to admin_hackathon_tickets_path(@application.hackathon), notice: "Checkin complete!"
    end

    def uncheckin
      @application = Application.find_by_id(params[:application_id])
        if @application.hackathon_id != @hackathon.id
          redirect_to root_path, notice: "Not authorized"
        end
      @application.update_attribute :checked_in, false
      redirect_to admin_hackathon_tickets_path(@application.hackathon), notice: "Un-checkin complete!"
    end

  # Applications
    def application_index
      if params[:accepted] == 't'
        @applications = Application.where(hackathon_id: @hackathon, accepted: true).all
      end

      if params[:accepted] == 'f'
        @applications = Application.where(hackathon_id: @hackathon, accepted: false).all
      end

      if params[:accepted] == nil
        @applications = Application.where(hackathon_id: @hackathon).all
      end
    end

    def application_show
      @application = Application.find_by_id(params[:application_id])
        if @application.hackathon_id != @hackathon.id
          redirect_to root_path, notice: "Not authorized"
        end
    end

    def application_accept
      @application = Application.find_by_id(params[:application_id])
        if @application.hackathon_id != @hackathon.id
          redirect_to root_path, notice: "Not authorized"
        end
      @application.update_attribute :accepted, true
      redirect_to admin_hackathon_applications_path(@hackathon), notice: "Acceptance complete!"
    end

    def application_unaccept
      @application = Application.find_by_id(params[:application_id])
        if @application.hackathon_id != @hackathon.id
          redirect_to root_path, notice: "Not authorized"
        end
      @application.update_attribute :accepted, false
      redirect_to admin_hackathon_applications_path(@hackathon), notice: "Unacceptance complete!"
    end

  private
    def set_hackathon
      @hackathon = Hackathon.find_by_id(params[:hackathon_id])
    end

    def is_organizer
      if @hackathon = current_user.hackathons.find_by_id(params[:hackathon_id])
        else redirect_to root_path, notice: "Not authorized" if @hackathon.nil?
      end

      if current_user.organizers.where(hackathon_id: @hackathon)
        else redirect_to root_path, notice: "Not authorized" if @organizer.nil?
      end
    end

    def hackathon_params
      params.require(:hackathon).permit(:name, :subdomain, :about, :tagline, :location, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned, :user_id)
    end
end
