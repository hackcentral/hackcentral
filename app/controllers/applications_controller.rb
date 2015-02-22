class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /applications
  # GET /applications.json
  def index
    @applications = Application.where(user_id: current_user.id).all
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
  end

  # GET /applications/new
  def new
    if(params.has_key?(:hackathon_id))
      @application = current_user.applications.build(hackathon_id: params[:hackathon_id]) #Application.new
    else
      redirect_to applications_path, notice: 'An application needs to have a hackathon_id.'
    end
  end

  # GET /applications/1/edit
  def edit
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = current_user.applications.build(application_params.merge(hackathon_id: params[:hackathon_id])) #Application.new(application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to @application, notice: 'Application was successfully created.' }

        UserMailer.delay.application_confirmation(@application.user, @application.hackathon)

        Analytics.track(
          user_id: "#{@application.user_id}",
          event: 'Created an application',
          properties: {
            hackathon_id: "#{@application.hackathon_id}",
            reimbursement_needed: "#{@application.reimbursement_needed}"})
      else
      end
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to @application, notice: 'Application was successfully updated.' }
      else
      end
    end
  end

  # DELETE /application/1
  # DELETE /application/1.json
  def destroy
    @application.destroy
    respond_to do |format|
      format.html { redirect_to applications_url, notice: 'Application was successfully destroyed.' }
    end
  end

  private
    def set_application
      @application = Application.find(params[:id])
    end

    def correct_user
      @application = current_user.applications.find_by(id: params[:id])
      redirect_to applications_path, notice: "Not authorized to edit this application" if @application.nil?
    end

    def application_params
      params.require(:application).permit(:reimbursement_needed, :accepted, :checked_in, :user_id, :profile_id, :hackathon_id)
    end
end
