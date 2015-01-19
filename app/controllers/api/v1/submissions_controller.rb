module Api
  module V1
    class SubmissionsController < ApplicationController
      protect_from_forgery unless: -> { request.format.json? }
      before_action :doorkeeper_authorize!
      before_action :set_submission, only: [:show, :update, :destroy]
      before_action :correct_user, only: [:update, :destroy]

      def index
        @submissions = Submission.where(hackathon_id: params[:hackathon_id]).all

        respond_to do |format|
          format.json { render :json => @submissions }
        end
      end

      def show
        respond_to do |format|
          format.json { render :json => @submission }
        end
      end

      def create
        @submission = Submission.create!(submission_params)
        @submission.user_id = current_user.id

        respond_to do |format|
          if @submission.save(submission_params)
            format.json { render :json => @submission, status: :created }
          else
            format.json { render :json => {}, status: 422}
          end
        end
      end

      def update
        respond_to do |format|
          if @submission.update(submission_params)
            format.json { render :json => @submission, status: :ok }
          else
            format.json { render :json => {}, status: 422}
          end
        end
      end

      def destroy
        @submission.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      def tag
        respond_with Submission.tagged_with(params[:tag])
      end

      private
        def set_submission
          @submission = Submission.find(params[:id])
        end

        def correct_user
          @submission = Submission.find(params[:id])
          if @submission.user_id == current_user.id
          else
            respond_to do |format|
              format.json { render :json => {}, status: 401} #if @application.nil?
            end
          end
        end

        def submission_params
          params.require(:submission).permit(:title, :tagline, :description, :video, :website, :tag_list, :user_id, :hackathon_id, :submitted_at, team_members_attributes: [:id, :submission_id, :user_id, :_destroy])
        end
    end
  end
end
