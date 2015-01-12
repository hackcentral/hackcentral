class HackathonsController < ApplicationController
  before_action :set_hackathon, only: [:destroy, :edit, :update]
  before_action :is_organizer, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
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

  # GET /hackathons/1/edit
#  def edit
#  end

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

#  # PATCH/PUT /hackathons/1
#  # PATCH/PUT /hackathons/1.json
#  def update
#    respond_to do |format|
#      if @hackathon.update(hackathon_params)
#        format.html { redirect_to hackathons_path, notice: 'Hackathon was successfully updated.' }
#      else
#        format.html { render :edit }
#      end
#    end
#  end

  # DELETE /hackathons/1
  # DELETE /hackathons/1.json
#  def destroy
#    @hackathon.destroy
#    respond_to do |format|
#      format.html { redirect_to hackathons_url, notice: 'Hackathon was successfully destroyed.' }
#    end
#  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hackathon
      @hackathon = Hackathon.find(params[:id])
    end

    def current_hackathon
      @current_hackathon ||= Hackathon.find_by_subdomain!(request.subdomain)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def hackathon_params
      params.require(:hackathon).permit(:name, :subdomain, :about, :tagline, :location, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned, :user_id)
    end
end
