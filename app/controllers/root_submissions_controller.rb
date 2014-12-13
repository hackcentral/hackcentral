class RootSubmissionsController < ApplicationController
  before_action :set_submission, only: [:show]

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
end
