class HackathonsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  #before_action :current_hackathon, only: [:show]

  # GET /hackathons
  # GET /hackathons.json
  def index
    @hackathons = Hackathon.all
  end

  # GET /hackathons/1
  # GET /hackathons/1.json
  def show
    @hackathon = current_hackathon#Hackathon.find_by_subdomain!(request.subdomain)
  end

  # GET /hackathons/new
  def new
    @hackathon = current_user.hackathons.build #Hackathon.new
  end

  # POST /hackathons
  # POST /hackathons.json
  def create
    @hackathon = current_user.hackathons.build(hackathon_params) #Hackathon.new(hackathon_params)

    respond_to do |format|
      if @hackathon.save
        format.html { redirect_to hackathons_path, notice: 'Hackathon was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def current_hackathon
      @current_hackathon ||= Hackathon.find_by_subdomain!(request.subdomain)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hackathon_params
      params.require(:hackathon).permit(:name, :subdomain, :about, :tagline, :location, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned, :user_id)
    end
end
