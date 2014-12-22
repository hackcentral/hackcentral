class Admin::DashboardsController < ApplicationController
  before_action :is_admin, only: [:index]
  before_action :is_mlh, only: [:mlh, :sanction, :unsanction]
  before_action :authenticate_user!

  # Admin Root
    def index
      @organizers = current_user.organizers.all
    end

  # Admin MLH
    def mlh_root
      @hackathons = Hackathon.all
    end

    def mlh_sanction
      @hackathon = Hackathon.find(params[:hackathon_id])
      @hackathon.update_attribute :mlh_sanctioned, true
      redirect_to admin_mlh_path, notice: "Sanctioning complete!"
    end

    def mlh_unsanction
      @hackathon = Hackathon.find(params[:hackathon_id])
      @hackathon.update_attribute :mlh_sanctioned, false
      redirect_to admin_mlh_path, notice: "Unsanctioning complete!"
    end

  private
    def is_admin
      if user_signed_in?
          if current_user.admin == false
            redirect_to root_path, notice: "Not authorized"
          else
          end
      else
      end
    end

    def is_mlh
      if user_signed_in?
          if current_user.mlh == false
            redirect_to root_path, notice: "Not authorized"
          else
          end
      else
      end
    end

end
