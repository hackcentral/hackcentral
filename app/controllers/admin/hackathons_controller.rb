class Admin::HackathonsController < ApplicationController
  before_action :set_hackathon
  before_action :is_organizer
  before_action :authenticate_user!

  # Root
    def index
      @hackathon = Hackathon.find_by(params[:id])
    end

  private
    def set_hackathon
      @hackathon = Hackathon.find_by(params[:hackathon_id])
    end

    def is_organizer
      if user_signed_in?
        if current_user.organizers.where(hackathon_id: @hackathon)
        else
          redirect_to root_path, notice: "Not authorized" if @organizer.nil?
        end
      else
      end
    end
end
