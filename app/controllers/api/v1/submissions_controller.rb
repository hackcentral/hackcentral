module Api
  module V1
    class SubmissionsController < ApplicationController
      protect_from_forgery unless: -> { request.format.json? }
      before_action :doorkeeper_authorize!
      respond_to :json

      def index
        respond_with Submission.where(hackathon_id: params[:hackathon_id]).all
      end

      def create
        respond_with submissions.create(params[:submission])
      end

      def update
        respond_with submissions.update(params[:submission])
      end

      def destroy
        respond_with submissions.destroy(params[:submission])
      end

      def tag
        respond_with Submission.tagged_with(params[:tag])
      end

      def show
        respond_with Submission.find(params[:id])
      end
    end
  end
end
