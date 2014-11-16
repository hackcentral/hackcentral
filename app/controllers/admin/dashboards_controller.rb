class Admin::DashboardsController < ApplicationController

  def index
  end

  def mlh
    @hackathon = Hackathon.all
  end

end
