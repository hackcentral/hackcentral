class RootSubmissions::LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_submission

  def create
    @submission.likes.where(user_id: current_user.id).first_or_create

    respond_to do |format|
      format.html { redirect_to @submission }
    end
  end

  def destroy
    @submission.likes.where(user_id: current_user.id).destroy_all

    respond_to do |format|
      format.html { redirect_to @submission }
    end
  end

  private
    def set_submission
      @submission = Submission.friendly.find(params[:submission_id])
    end
end
