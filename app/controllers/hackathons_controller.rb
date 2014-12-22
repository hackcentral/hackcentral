class HackathonsController < ApplicationController
  before_action :set_root_hackathon, only: [:show, :destroy]
  before_action :set_admin_hackathon, only: [:edit, :update]
  before_action :is_organizer, only: [:edit, :update, :destroy]

  # GET /hackathons
  # GET /hackathons.json
  def index
    @hackathons = Hackathon.all
  end

  # GET /hackathons/1
  # GET /hackathons/1.json
  def show
    #@hackathon = Hackathon.find_by_subdomain!(request.subdomain)
  end

  # GET /hackathons/new
  def new
    @hackathon = Hackathon.new
  end

  # GET /hackathons/1/edit
  def edit
  end

  # POST /hackathons
  # POST /hackathons.json
  def create
    @hackathon = Hackathon.new(hackathon_params)

    respond_to do |format|
      if @hackathon.save
        format.html { redirect_to hackathons_path, notice: 'Hackathon was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /hackathons/1
  # PATCH/PUT /hackathons/1.json
  def update
    respond_to do |format|
      if @hackathon.update(hackathon_params)
        format.html { redirect_to hackathons_path, notice: 'Hackathon was successfully updated.' }
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
      format.html { redirect_to hackathons_url, notice: 'Hackathon was successfully destroyed.' }
    end
  end

  # /admin/hackathons/1/checkin
  def checkin
    #@hackathon = Hackathon.all
    #@hackathon = Hackathon.applications.where(accepted: true).all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_root_hackathon
      @hackathon = Hackathon.find(params[:id])
    end

    def set_admin_hackathon
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def hackathon_params
      params.require(:hackathon).permit(:name, :subdomain, :about, :tagline, :location, :logo, :header, :start, :end, :hs_hackers_allowed, :mlh_sanctioned)
    end
end
