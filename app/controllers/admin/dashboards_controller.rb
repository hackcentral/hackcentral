class Admin::DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_mlh, only: [:mlh_root, :mlh_sanction, :mlh_unsanction]

  # Admin Root
    def index
      @hackathons = Hackathon.where(user_id: current_user).all
      @organizers = current_user.organizers.all
    end

  # Admin MLH
    def mlh_root
      @hackathons = Hackathon.all
    end

    def mlh_sanction
      @hackathon = Hackathon.find_by_id(params[:hackathon_id])
      @hackathon.update_attribute :mlh_sanctioned, true
      redirect_to admin_mlh_path, notice: "Sanctioning complete!"
    end

    def mlh_unsanction
      @hackathon = Hackathon.find_by_id(params[:hackathon_id])
      @hackathon.update_attribute :mlh_sanctioned, false
      redirect_to admin_mlh_path, notice: "Unsanctioning complete!"
    end

  private
    def is_mlh
      if current_user.mlh?
      else redirect_to root_path, notice: "Not authorized"
      end
    end

end