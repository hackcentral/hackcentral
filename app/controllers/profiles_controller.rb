class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.where(user_id: current_user.id).all
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
  end

  # GET /profiles/new
  def new
    @profile = current_user.profiles.build #Profile.new
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = current_user.profiles.build(profile_params) #Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile)
        format.html { redirect_to @profile, notice: 'Profile was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /profile/1
  # DELETE /profile/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
    end
  end

  private
    def set_profile
      @profile = Profile.find(params[:id])
    end

    def correct_user
      @profile = current_user.profiles.find_by(id: params[:id])
      redirect_to profiles_path, notice: "Not authorized to edit this profile" if @profile.nil?
    end

    def profile_params
      params.require(:profile).permit(:name, :first_name, :last_name, :email, :school_grad, :bio, :website, :github, :dietary_needs, :resume, :user_id)
    end
end
