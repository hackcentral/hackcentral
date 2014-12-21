class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]

  def index
    @organizers = Organizer.all
    respond_with(@organizers)
  end

  def show
    respond_with(@organizer)
  end

  def new
    @organizer = Organizer.new
    respond_with(@organizer)
  end

  def edit
  end

  def create
    @organizer = Organizer.new(organizer_params)
    @organizer.save
    respond_with(@organizer)
  end

  def update
    @organizer.update(organizer_params)
    respond_with(@organizer)
  end

  def destroy
    @organizer.destroy
    respond_with(@organizer)
  end

  private
    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    def organizer_params
      params.require(:organizer).permit(:user_id, :hackathon_id)
    end
end
