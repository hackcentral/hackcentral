class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:destroy]
  before_action :set_hackathon

  def index
    @organizers = Organizer.where(hackathon_id: @hackathon).all
  end

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = @hackathon.organizers.build(organizer_params)

    respond_to do |format|
      if @organizer.save
        format.html { redirect_to admin_hackathon_path(@organizer.hackathon_id), notice: 'Organizer was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @organizer.destroy
    respond_to do |format|
      format.html { redirect_to admin_hackathon_url, notice: 'Organizer was successfully destroyed.' }
    end
  end

  private
    def set_hackathon
      @hackathon = Hackathon.find(params[:hackathon_id])
    end

    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    def organizer_params
      params.require(:organizer).permit(:user_username, :user_id, :hackathon_id)
    end
end
