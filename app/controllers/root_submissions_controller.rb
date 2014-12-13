class RootSubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy]
  #before_action :correct_user, only: [:edit, :update, :destroy]

  def tag
    @submissions = Submission.tagged_with(params[:tag])
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @hackathon = @submission.hackathon_id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def submission_params
      #params.require(:submission).permit(:title, :tagline, :description, :video, :website, :tag_list, :user_id, :hackathon_id, :submitted_at)
    #end
end
