class SubmissionsController < ApplicationController
  before_action :set_hackathon, except: [:tag, :show]
  before_action :set_hackathon_submission, only: [:edit, :update, :destroy]
  before_action :set_submission, only: [:show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /submissions
  # GET /submissions.json
  def index
    #@submissions = Submission.where(:hackathon_id => @hackathon).paginate(:page => params[:page], :per_page => 30) #Submission.all
    @submissions = Submission.where(:hackathon_id => @hackathon).paginate(:page => params[:page]).order('id DESC')
  end

  def tag
    @submissions = Submission.tagged_with(params[:tag])
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @hackathon = @submission.hackathon_id
    @team_members = TeamMember.where(submission_id: @submission).all

    if @submission.video?
      @c = Conred::Video.new(
        video_url: @submission.video,
        width: 285,
        height: 185,
        error_message: "Video url is invalid"
      )
    end
  end

  # GET /submissions/new
  def new
    @submission = @hackathon.submissions.build(user_id: current_user.id) #Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions
  # POST /submissions.json
  def create
    @submission = @hackathon.submissions.build(submission_params.merge(user_id: current_user.id)) #Submission.new(submission_params)
    @submission.submitted_at = Time.now if submitting?

    respond_to do |format|
      if @submission.save
        format.html { redirect_to hackathon_submissions_path, notice: 'Submission was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    @submission.submitted_at = Time.now if submitting?

    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to hackathon_submissions_path, notice: 'Submission was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to hackathon_submissions_path, notice: 'Submission was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hackathon_submission
      @submission = @hackathon.submissions.friendly.find(params[:id])
    end

    def set_submission
      @submission = Submission.friendly.find(params[:id])
    end

    def set_hackathon
      @hackathon = Hackathon.find_by_id(params[:hackathon_id])
    end

    def submitting?
      params[:commit] == "Submit"
    end

    def correct_user
      @submission = current_user.submissions.friendly.find(params[:id])
      redirect_to hackathon_submissions_path(@hackathon), notice: "Not authorized to edit this submission" if @submission.nil?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def submission_params
      params.require(:submission).permit(:title, :tagline, :description, :video, :website, :tag_list, :user_id, :hackathon_id, :submitted_at, team_members_attributes: [:id, :submission_id, :user_id, :_destroy])
    end
end