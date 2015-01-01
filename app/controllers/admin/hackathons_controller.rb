class Admin::HackathonsController < ApplicationController
  before_action :set_hackathon
  before_action :is_organizer
  before_action :authenticate_user!

  # Root
    def index
      @organizers = Organizer.all
    end

  # Check in
    def checkin_index
      @applications = Application.where(hackathon_id: @hackathon, accepted: true).all
    end
    def checkin
      @application = Application.find(params[:application_id])
      @application.update_attribute :checked_in, true
      redirect_to admin_hackathon_tickets_path(@application.hackathon), notice: "Checkin complete!"
    end
    def uncheckin
      @application = Application.find(params[:application_id])
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
        @applications = Application.where(hackathon_id: Hackathon.find_by(params[:hackathon_id])).all
      end
    end
    def application_show
      @application = Application.find(params[:application_id])
    end
    def application_accept
      @application = Application.find(params[:application_id])
      @application.update_attribute :accepted, true
      redirect_to admin_hackathon_applications_path(@hackathon), notice: "Acceptance complete!"
    end
    def application_unaccept
      @application = Application.find(params[:application_id])
      @application.update_attribute :accepted, false
      redirect_to admin_hackathon_applications_path(@hackathon), notice: "Unacceptance complete!"
    end

  private
    def set_hackathon
      @hackathon = Hackathon.find_by(params[:id])
    end

    def is_organizer
      if user_signed_in?
        if @hackathon = current_user.hackathons.find_by(id: params[:id])
          else redirect_to root_path, notice: "Not authorized" if @hackathon.nil?
        end

        if current_user.organizers.where(hackathon_id: @hackathon)
          else redirect_to root_path, notice: "Not authorized" if @organizer.nil?
        end
      else
      end
    end
end
