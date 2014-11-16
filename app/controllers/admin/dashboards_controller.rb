class Admin::DashboardsController < ApplicationController
  before_action :is_mlh, only: [:mlh]
  before_action :authenticate_user!

  def index
  end

  def mlh
    @hackathon = Hackathon.all
  end

  private
    def is_mlh
      if current_user.mlh == false
        redirect_to root_path, notice: "Not authorized"
      end
    end
end
